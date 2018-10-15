require 'test_helper'

class HotkeyTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotkey_type = hotkey_types(:one)
  end

  test "should get index" do
    get hotkey_types_url
    assert_response :success
  end

  test "should get new" do
    get new_hotkey_type_url
    assert_response :success
  end

  test "should create hotkey_type" do
    assert_difference('HotkeyType.count') do
      post hotkey_types_url, params: { hotkey_type: { name: @hotkey_type.name } }
    end

    assert_redirected_to hotkey_type_url(HotkeyType.last)
  end

  test "should show hotkey_type" do
    get hotkey_type_url(@hotkey_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotkey_type_url(@hotkey_type)
    assert_response :success
  end

  test "should update hotkey_type" do
    patch hotkey_type_url(@hotkey_type), params: { hotkey_type: { name: @hotkey_type.name } }
    assert_redirected_to hotkey_type_url(@hotkey_type)
  end

  test "should destroy hotkey_type" do
    assert_difference('HotkeyType.count', -1) do
      delete hotkey_type_url(@hotkey_type)
    end

    assert_redirected_to hotkey_types_url
  end
end
