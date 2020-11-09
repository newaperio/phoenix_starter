defmodule PhoenixStarterWeb.RequireUserPermission do
  @moduledoc """
  This `Plug` requires the `current_user` to have the correct permissions and redirects otherwise.

  Permissions map to `PhoenixStarter.Users.UserRole`.

  ## Usage

  ```
  plug RequireUserPermission, permission: "me.update_profile"
  ```
  """
  import PhoenixStarterWeb.Gettext
  import Plug.Conn
  import Phoenix.Controller

  alias PhoenixStarter.Users

  def init(opts) do
    permission = Keyword.get(opts, :permission, nil)

    if !is_binary(permission) do
      raise ArgumentError, """
      PhoenixStarterWeb.RequireUserPermission must have a `permission` option.
      For example:

          plug RequireUserPermission, permission: "me.update_profile"
      """
    end
  end

  def call(%Plug.Conn{assigns: %{current_user: user}} = conn, permission: permission) do
    if Users.permitted?(user, permission) do
      conn
    else
      conn
      |> put_flash(:error, gettext("You are not authorized to perform this action."))
      |> redirect(to: "/")
      |> halt()
    end
  end

  def call(conn, _), do: conn
end
