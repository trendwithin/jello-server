require 'test_helper'

class V2::CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @card = cards(:active)
    @list = lists(:active)
    @user = users(:admin)
    @card_attributes = {
      list_id: @list.id,
      creator_id: @user.id,
      assignee_id: @user.id,
      title: 'Another Card',
      description: 'This is a card.',
      archived: false
    }
  end

  test "should get index" do
    get v2_cards_url,
        headers: authorization_headers(user: @user),
        as: :json
    assert_response :success
  end

  test "should create card" do
    assert_difference('Card.count') do
      post v2_cards_url,
           params: { card: @card_attributes },
           headers: authorization_headers(user: @user),
           as: :json
    end

    assert_response 201
  end

  test "should show card" do
    get v2_card_url(@card),
        headers: authorization_headers(user: @user),
        as: :json
    assert_response :success
  end

  test "should update card" do
    patch v2_card_url(@card),
          params: { card: @card_attributes },
          headers: authorization_headers(user: @user),
          as: :json
    assert_response 200
  end

  test "should destroy card" do
    assert_difference('Card.count', -1) do
      delete v2_card_url(@card),
             headers: authorization_headers(user: @user),
             as: :json
    end

    assert_response 204
  end
end
