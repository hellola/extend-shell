require 'test_helper'

class EnvironmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @environment = environments(:one)
  end

  test "should get index" do
    get environments_url
    assert_response :success
  end

  test "should get new" do
    get new_environment_url
    assert_response :success
  end

  test "should create environment" do
    assert_difference('Environment.count') do
      post environments_url, params: { environment: { location_id: @environment.location_id, name: @environment.name, operating_system_id: @environment.operating_system_id, value: @environment.value } }
    end

    assert_redirected_to environment_url(Environment.last)
  end

  test "should show environment" do
    get environment_url(@environment)
    assert_response :success
  end

  test "should get edit" do
    get edit_environment_url(@environment)
    assert_response :success
  end

  test "should update environment" do
    patch environment_url(@environment), params: { environment: { location_id: @environment.location_id, name: @environment.name, operating_system_id: @environment.operating_system_id, value: @environment.value } }
    assert_redirected_to environment_url(@environment)
  end

  test "should destroy environment" do
    assert_difference('Environment.count', -1) do
      delete environment_url(@environment)
    end

    assert_redirected_to environments_url
  end
end
