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

      assert_equal user_url(@user), response_user['links'][0]['href']

      board_ids = @user.boards.where(archived: [false, nil]).pluck(:id)
      response_boards = response_user['boards']
      assert_equal board_ids.sort, response_boards.map { |b| b['id'] }.sort

      archived_board_ids = @user.boards.where(archived: true).pluck(:id)
      response_archived_boards = response_user['archived_boards']
      assert_equal archived_board_ids.sort,
                   response_archived_boards.map { |b| b['id'] }.sort
    end
  end

  describe 'POST /users' do
  end

  describe 'PATCH /users/:id' do
  end

  describe 'DELETE /users/:id' do
  end
end
