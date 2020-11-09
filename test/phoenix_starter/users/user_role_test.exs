defmodule PhoenixStarter.Users.UserRoleTest do
  use PhoenixStarter.DataCase

  alias PhoenixStarter.Users.UserRole

  test "roles/0" do
    assert UserRole.roles() == [:admin, :ops_admin, :user]
  end

  test "role/1" do
    assert %UserRole{} = UserRole.role(:admin)

    assert_raise ArgumentError, fn ->
      UserRole.role(:notarole)
    end
  end
end
