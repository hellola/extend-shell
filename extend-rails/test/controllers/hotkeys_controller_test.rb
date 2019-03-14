require 'test_helper'

class HotkeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotkey = hotkeys(:one)
  end

  test "should get index" do
    get hotkeys_url
    assert_response :success
  end

  test "should get new" do
    get new_hotkey_url
    assert_response :success
  end

  test "should create hotkey" do
    assert_difference('Hotkey.count') do
      post hotkeys_url, params: { hotkey: { command: @hotkey.command, executes: @hotkey.executes, hotkey_type_id: @hotkey.hotkey_type_id, key: @hotkey.key, location_id: @hotkey.location_id, name: @hotkey.name, operating_system_id: @hotkey.operating_system_id, parent_id: @hotkey.parent_id } }
    end

    assert_redirected_to hotkey_url(Hotkey.last)
  end

  test "should show hotkey" do
    get hotkey_url(@hotkey)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotkey_url(@hotkey)
    assert_response :success
  end

  test "should update hotkey" do
    patch hotkey_url(@hotkey), params: { hotkey: { command: @hotkey.command, executes: @hotkey.executes, hotkey_type_id: @hotkey.hotkey_type_id, key: @hotkey.key, location_id: @hotkey.location_id, name: @hotkey.name, operating_system_id: @hotkey.operating_system_id, parent_id: @hotkey.parent_id } }
    assert_redirected_to hotkey_url(@hotkey)
  end

  test "should destroy hotkey" do
    assert_difference('Hotkey.count', -1) do
      delete hotkey_url(@hotkey)
    end

    assert_redirected_to hotkeys_url
  end
end
