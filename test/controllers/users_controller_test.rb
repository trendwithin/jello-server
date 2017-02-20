require 'test_helper'

describe UsersController do
  before do
    @user = users(:admin)
  end

  describe 'GET /users' do
    it 'should successfully fetch all Users' do
      @expected_users = User.all

      get users_url, as: :json
      assert_response :ok

      response_users = json_response['users']
      assert_instance_of Array, response_users

      response_ids = response_users.map { |u| u['id'] }
      assert_equal @expected_users.ids.sort, response_ids.sort
    end
  end

  describe 'GET /users/:id' do
    it 'should successfully fetch the requested User' do
      get user_url(@user)
      assert_response :ok

      response_user = json_response['user']
      assert_equal @user.id, response_user['id']
      assert_equal @user.email, response_user['email']
      assert_equal @user.gravatar_url, response_user['gravatar_url']

      assert_equal user_url(@user), response_user.dig('links', 0, 'href')

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
        get user_url(id: 'jim')
        assert_response :not_found

        response_error = json_response['error']
        refute_nil response_error

        assert_equal 404, response_error['status']
        assert_equal 'Not found', response_error['name']
        refute_nil response_error['message']
      end
    end
  end

  describe 'POST /users' do
    it 'should create and respond with a new User' do
      user_attributes = {
        email: 'jim@example.com',
        password: 'secret',
        password_confirmation: 'secret'
      }

      assert_difference('User.count') do
        post users_url, params: { user: user_attributes }, as: :json
      end

      assert_response :created

      response_user = json_response['user']
      assert_equal user_attributes[:email], response_user['email']
      refute_nil response_user['gravatar_url']

      user = User.find(response_user['id'])
      assert_equal user_url(user), response_user.dig('links', 0, 'href')

      assert_empty response_user['boards']
      assert_empty response_user['archived_boards']
    end
  end

  describe 'PATCH /users/:id' do
  end

  describe 'DELETE /users/:id' do
  end
end
