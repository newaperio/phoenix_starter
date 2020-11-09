defmodule PhoenixStarterWeb.RequireUserPermissionTest do
  use PhoenixStarterWeb.ConnCase

  import PhoenixStarter.UsersFixtures

  alias PhoenixStarterWeb.RequireUserPermission

  test "init raises without permission option" do
    assert_raise ArgumentError, fn ->
      RequireUserPermission.init([])
    end
  end

  test "redirects if permission not given" do
    user = user_fixture()

    conn =
      build_conn()
      |> log_in_user(user)
      |> bypass_through(PhoenixStarterWeb.Router, [:browser])
      |> get("/")
      |> RequireUserPermission.call(permission: "ops.dashboard")

    assert conn.halted
    assert redirected_to(conn) == "/"
    assert get_flash(conn, :error) == "You are not authorized to perform this action."
  end

  test "doesn't redirect if permission given" do
    user = user_fixture(%{role: :ops_admin})

    conn =
      build_conn()
      |> log_in_user(user)
      |> bypass_through(PhoenixStarterWeb.Router, [:browser])
      |> get("/")

    assert RequireUserPermission.call(conn, permission: "ops.dashboard") == conn
  end
end
