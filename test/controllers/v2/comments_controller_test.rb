require 'test_helper'

class V2::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comment = comments(:active)
    @card = cards(:active)
    @user = users(:admin)
    @comment_attributes = {
      card_id: @card.id,
      creator_id: @user.id,
      body: 'This is a comment.'
    }
  end

  test "should get index" do
    get v2_comments_url, as: :json
    assert_response :success
  end

  test "should create comment" do
    assert_difference('Comment.count') do
      post v2_comments_url, params: { comment: @comment_attributes }, as: :json
    end

    assert_response 201
  end

  test "should show comment" do
    get v2_comment_url(@comment), as: :json
    assert_response :success
  end

  test "should update comment" do
    patch v2_comment_url(@comment), params: { comment: @comment_attributes }, as: :json
    assert_response 200
  end

  test "should destroy comment" do
    assert_difference('Comment.count', -1) do
      delete v2_comment_url(@comment), as: :json
    end

    assert_response 204
  end
end
