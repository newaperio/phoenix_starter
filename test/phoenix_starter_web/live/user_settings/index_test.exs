defmodule PhoenixStarterWeb.UserSettingsLive.IndexTest do
  use PhoenixStarterWeb.ConnCase

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  test "renders profile component", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_settings_path(conn, :profile))

    assert page_title(view) =~ "Update Profile"
    assert html =~ "Update Profile"
  end

  test "renders email component", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_settings_path(conn, :email))

    assert page_title(view) =~ "Update Email"
    assert html =~ "Update Email"
  end

  test "renders password component", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.user_settings_path(conn, :password))

    assert page_title(view) =~ "Update Password"
    assert html =~ "Update Password"
  end
end
