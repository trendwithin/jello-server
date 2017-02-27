require 'test_helper'

describe V2::UsersController do
  before do
    @user = users(:admin)
    @per_page = 3
  end

  describe 'GET /v2/users' do
    it 'should successfully fetch the first page of Users' do
      page = 1
      User.stub(:default_per_page, @per_page) do
        @expected_users = User.page(page)
        get v2_users_url,
            headers: authorization_headers(user: @user),
            as: :json
      end

      assert_response :ok
      assert_equal 'application/json', response.content_type

      response_users = json_response['users']
      assert_instance_of Array, response_users
      assert_equal @per_page, response_users.count

      response_ids = response_users.map { |u| u['id'] }
      assert_equal @expected_users.ids.sort, response_ids.sort

      user_count = User.count
      response_meta = json_response.dig('meta')
      assert_equal page, response_meta['current_page']
      assert_equal page+1, response_meta['next_page']
      assert_nil response_meta['prev_page']
      assert_equal user_count, response_meta['total_count']
      assert_equal (user_count.to_f / @per_page.to_f).ceil,
                   response_meta['total_pages']
    end

    it 'should paginate the fetched Users' do
      page = 3
      User.stub(:default_per_page, @per_page) do
        @expected_users = User.page(page)
        get v2_users_url(page: page),
            headers: authorization_headers(user: @user),
            as: :json
      end

      response_users = json_response['users']
      response_ids = response_users.map { |u| u['id'] }
      assert_equal @expected_users.ids.sort, response_ids.sort

      response_meta = json_response.dig('meta')
      assert_equal page, response_meta['current_page']
      assert_equal page+1, response_meta['next_page']
      assert_equal page-1, response_meta['prev_page']
    end
  end

  describe 'GET /v2/users/:id' do
    it 'should successfully fetch the requested User' do
      get v2_user_url(@user),
          headers: authorization_headers(user: @user),
          as: :json
      assert_response :ok

      response_user = json_response['user']
      assert_equal @user.id, response_user['id']
      assert_equal @user.email, response_user['email']
      assert_equal @user.gravatar_url, response_user['gravatar_url']

      assert_equal v2_user_url(@user), response_user.dig('links', 0, 'href')

      board_ids = @user.boards.where(archived: [false, nil]).pluck(:id)
      response_boards = response_user['boards']
      assert_equal board_ids.sort, response_boards.map { |b| b['id'] }.sort

      archived_board_ids = @user.boards.where(archived: true).pluck(:id)
      response_archived_boards = response_user['archived_boards']
      assert_equal archived_board_ids.sort,
                   response_archived_boards.map { |b| b['id'] }.sort
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        get v2_user_url(id: 'jim'),
            headers: authorization_headers(user: @user),
            as: :json
        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end
  end

  describe 'POST /v2/users' do
    it 'should create and respond with a new User' do
      user_attributes = {
        email: 'jim@example.com',
        password: 'secret',
        password_confirmation: 'secret'
      }

      assert_difference('User.count') do
        post v2_users_url,
             params: { user: user_attributes },
             headers: authorization_headers(user: @user),
             as: :json
      end

      assert_response :created

      response_user = json_response['user']
      assert_equal user_attributes[:email], response_user['email']
      refute_nil response_user['gravatar_url']

      user = User.find(response_user['id'])
      assert_equal v2_user_url(user), response_user.dig('links', 0, 'href')

      assert_empty response_user['boards']
      assert_empty response_user['archived_boards']
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        assert_no_difference('User.count') do
          post v2_users_url,
               params: { user: user_attributes },
               headers: authorization_headers(user: @user),
               as: :json
        end

        assert_response :unprocessable_entity

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 422, response_error['status']
        assert_equal 'Validation failed', response_error['name']

        response_errors = response_error['errors']
        assert_equal ["can't be blank"], response_errors['email']
        assert_equal ["can't be blank"], response_errors['password']
      end
    end
  end

  describe 'PATCH /v2/users/:id' do
    it 'should update the requested User' do
      user_attributes = { email: 'jim@example.com' }

      update_time = 1.day.from_now.change(usec: 0)  # truncate milliseconds
      travel_to update_time

      patch v2_user_url(@user),
            params: { user: user_attributes },
            headers: authorization_headers(user: @user),
            as: :json
      assert_response :ok

      response_user = json_response['user']
      assert_equal user_attributes[:email], response_user['email']
      assert_equal update_time.as_json, response_user['updated_at']

      travel_back
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        user_attributes = { email: 'jim@example.com' }

        patch v2_user_url(id: 'jim'),
              params: { user: user_attributes },
              headers: authorization_headers(user: @user),
              as: :json
        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end

    describe 'with invalid User attributes' do
      it 'should respond with validation errors' do
        user_attributes = { email: '' }

        patch v2_user_url(@user),
              params: { user: user_attributes },
              headers: authorization_headers(user: @user),
              as: :json
        assert_response :unprocessable_entity

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 422, response_error['status']
        assert_equal 'Validation failed', response_error['name']

        response_errors = response_error['errors']
        assert_equal ["can't be blank"], response_errors['email']
      end
    end
  end

  describe 'DELETE /v2/users/:id' do
    it 'should successfully delete the requested User' do
      assert_difference('User.count', -1) do
        delete v2_user_url(@user),
               headers: authorization_headers(user: @user),
               as: :json
      end

      assert_response :no_content
      assert_empty response.body
    end

    describe 'when :id is unknown' do
      it 'should respond with :not_found' do
        assert_no_difference('User.count') do
          delete v2_user_url(id: 'jim'),
                 headers: authorization_headers(user: @user),
                 as: :json
        end

        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end
  end
end
