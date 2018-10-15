require 'test_helper'

class AliasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @alias = aliases(:one)
  end

  test "should get index" do
    get aliases_url
    assert_response :success
  end

  test "should get new" do
    get new_alias_url
    assert_response :success
  end

  test "should create alias" do
    assert_difference('Alias.count') do
      post aliases_url, params: { alias: { command: @alias.command, location_id: @alias.location_id, name: @alias.name, operating_system_id: @alias.operating_system_id } }
    end

    assert_redirected_to alias_url(Alias.last)
  end

  test "should show alias" do
    get alias_url(@alias)
    assert_response :success
  end

  test "should get edit" do
    get edit_alias_url(@alias)
    assert_response :success
  end

  test "should update alias" do
    patch alias_url(@alias), params: { alias: { command: @alias.command, location_id: @alias.location_id, name: @alias.name, operating_system_id: @alias.operating_system_id } }
    assert_redirected_to alias_url(@alias)
  end

  test "should destroy alias" do
    assert_difference('Alias.count', -1) do
      delete alias_url(@alias)
    end

    assert_redirected_to aliases_url
  end
end
