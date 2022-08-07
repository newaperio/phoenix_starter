defmodule PhoenixStarterWeb.UserSettingsController do
  use PhoenixStarterWeb, :controller

  alias PhoenixStarter.Users
  alias PhoenixStarterWeb.UserAuth

  plug :assign_email_and_password_changesets

  def update_password(conn, %{"current_password" => password, "user" => user_params}) do
    user = conn.assigns.current_user

    case Users.update_user_password(user, password, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:success, gettext("Your password was updated successfully."))
        |> put_session(:user_return_to, Routes.user_settings_path(conn, :password))
        |> UserAuth.log_in_user(user)

      _ ->
        conn
        |> put_flash(:error, gettext("We were unable to update your password. Please try again."))
        |> redirect(to: Routes.user_settings_path(conn, :password))
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Users.update_user_email(conn.assigns.current_user, token) do
      :ok ->
        conn
        |> put_flash(:success, gettext("Your email was updated successfully."))
        |> redirect(to: Routes.user_settings_path(conn, :email))

      :error ->
        conn
        |> put_flash(
          :error,
          gettext("The email change link is invalid or it has expired. Please try again.")
        )
        |> redirect(to: Routes.user_settings_path(conn, :email))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    user = conn.assigns.current_user

    conn
    |> assign(:email_changeset, Users.change_user_email(user))
    |> assign(:password_changeset, Users.change_user_password(user))
  end
end
