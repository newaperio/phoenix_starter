defmodule PhoenixStarterWeb.UserSettingsLive.EmailComponentTest do
  use PhoenixStarterWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhoenixStarter.UsersFixtures

  alias PhoenixStarter.Users

  @form_id "#form__update-email"

  setup [:register_and_log_in_user]

  test "validates", %{conn: conn, user: user} do
    {:ok, live, _html} = live(conn, Routes.user_settings_path(conn, :email))

    error_html =
      assert live
             |> form(@form_id, user: %{email: user.email}, current_password: "")
             |> render_change()

    assert error_html =~ "did not change"
    assert error_html =~ "is not valid"
  end

  test "saves", %{conn: conn, user: user} do
    {:ok, live, _html} = live(conn, Routes.user_settings_path(conn, :email))

    # Must render change first to persist changeset
    _html =
      live
      |> form(@form_id,
        user: %{email: "skywalker@example.com"},
        current_password: valid_user_password()
      )
      |> render_change()

    html =
      live
      |> form(@form_id,
        user: %{email: "skywalker@example.com"},
        current_password: valid_user_password()
      )
      |> render_submit()

    user = Users.get_user_by_email(user.email)
    assert user.email != "skywalker@example.com"

    assert html =~ "A link to confirm your e-mail change has been sent to the new address."
  end
end
