require 'test_helper'

class ActivityGroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @activity_group = activity_groups(:one)
  end

  test "should get index" do
    get activity_groups_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_group_url
    assert_response :success
  end

  test "should create activity_group" do
    assert_difference('ActivityGroup.count') do
      post activity_groups_url, params: { activity_group: { name: @activity_group.name } }
    end

    assert_redirected_to activity_group_url(ActivityGroup.last)
  end

  test "should show activity_group" do
    get activity_group_url(@activity_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_activity_group_url(@activity_group)
    assert_response :success
  end

  test "should update activity_group" do
    patch activity_group_url(@activity_group), params: { activity_group: { name: @activity_group.name } }
    assert_redirected_to activity_group_url(@activity_group)
  end

  test "should destroy activity_group" do
    assert_difference('ActivityGroup.count', -1) do
      delete activity_group_url(@activity_group)
    end

    assert_redirected_to activity_groups_url
  end
end
