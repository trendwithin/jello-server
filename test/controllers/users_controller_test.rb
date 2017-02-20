require 'test_helper'

describe UsersController do
  before do
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
  end

  describe 'POST /users' do
  end

  describe 'PATCH /users/:id' do
  end

  describe 'DELETE /users/:id' do
  end
end
