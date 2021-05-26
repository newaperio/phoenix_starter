defmodule PhoenixStarterWeb.UserSettingsLive.PasswordComponentTest do
  use PhoenixStarterWeb.ConnCase

  import Phoenix.LiveViewTest
  import PhoenixStarter.UsersFixtures

  @form_id "#form__update-password"

  setup [:register_and_log_in_user]

  test "validates", %{conn: conn} do
    {:ok, live, _html} = live(conn, Routes.user_settings_path(conn, :password))

    error_html =
      assert live
             |> form(@form_id,
               user: %{password: "password", password_confirmation: "new password"},
               current_password: ""
             )
             |> render_change()

    assert error_html =~ "does not match password"
    assert error_html =~ "is not valid"
  end

  test "saves", %{conn: conn} do
    {:ok, live, _html} = live(conn, Routes.user_settings_path(conn, :password))

    # Must render change first to persist changeset
    _html =
      live
      |> form(@form_id,
        user: %{password: "new password", password_confirmation: "new password"},
        current_password: valid_user_password()
      )
      |> render_change()

    form =
      form(live, @form_id,
        user: %{password: "new password", password_confirmation: "new password"},
        current_password: valid_user_password(),
        _method: "put"
      )

    assert render_submit(form) =~ ~r/phx-trigger-action/

    conn = follow_trigger_action(form, conn)

    assert redirected_to(conn) =~ Routes.user_settings_path(conn, :password)
    assert get_flash(conn, :info) =~ "Password updated successfully."
  end
end
