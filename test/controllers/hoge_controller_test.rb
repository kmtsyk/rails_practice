require "test_helper"

class HogeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get hoge_index_url
    assert_response :success
  end

  test "should get show" do
    get hoge_show_url
    assert_response :success
  end

  test "should get new" do
    get hoge_new_url
    assert_response :success
  end
end
