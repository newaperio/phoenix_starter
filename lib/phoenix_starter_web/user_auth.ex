defmodule PhoenixStarterWeb.UserAuth do
  @moduledoc """
  Session helpers to authentication.
  """
  import Phoenix.Controller
  import PhoenixStarterWeb.Gettext
  import Plug.Conn

  alias Phoenix.LiveView
  alias PhoenixStarter.Users
  alias PhoenixStarterWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in `PhoenixStarter.Users.UserToken`.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_phoenix_starter_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the `PhoenixStarter.Users.User` in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  @spec log_in_user(Plug.Conn.t(), Users.User.t(), map) :: Plug.Conn.t()
  def log_in_user(conn, user, params \\ %{}) do
    token = Users.generate_user_session_token(user)
    user_return_to = get_session(conn, :user_return_to)

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the `PhoenixStarter.Users.User` out.

  It clears all session data for safety. See renew_session.
  """
  @spec log_out_user(Plug.Conn.t()) :: Plug.Conn.t()
  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Users.delete_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      PhoenixStarterWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the `PhoenixStarter.Users.User` by looking into the session
  and remember me token.
  """
  @spec fetch_current_user(Plug.Conn.t(), any) :: Plug.Conn.t()
  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)
    user = user_token && Users.get_user_by_session_token(user_token)
    assign(conn, :current_user, user)
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_token_in_session(conn, user_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Handles mounting and authenticating the current_user in LiveViews.

  ## `on_mount` arguments

    * `:mount_current_user` - Assigns current_user to socket assigns based on
       user_token, or nil if there's no user_token or no matching user.

    * `:ensure_authenticated` - Authenticates the user from the session, and
       assigns the current_user to socket assigns based on user_token. Redirects to
       login page if there's no logged in user.

    * `:redirect_if_user_is_authenticated` - Authenticates the user from the
      session. Redirects to signed_in_path if there's a logged in user.

  ## Examples

  Use the `on_mount` lifecycle macro in LiveViews to mount or authenticate
  the current_user:

      defmodule PhoenixStarterWeb.PageLive do
        use PhoenixStarterWeb, :live_view
        on_mount {PhoenixStarterWeb.UserAuth, :mount_current_user}
        ...
      end

  Or use the `live_session` of your router to invoke the on_mount callback:

      live_session :authenticated, on_mount: [{PhoenixStarterWeb.UserAuth, :ensure_authenticated}] do
        live "/profile", ProfileLive, :index
      end

  """
  def on_mount(:mount_current_user, _params, session, socket) do
    {:cont, mount_current_user(session, socket)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> LiveView.put_flash(:error, gettext("You must log in to access this page."))
        |> LiveView.redirect(to: Routes.user_session_path(PhoenixStarterWeb.Endpoint, :new))

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user(session, socket)

    if socket.assigns.current_user do
      {:halt, LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_current_user(session, socket) do
    case session do
      %{"user_token" => user_token} ->
        LiveView.assign_new(socket, :current_user, fn ->
          Users.get_user_by_session_token(user_token)
        end)

      %{} ->
        LiveView.assign_new(socket, :current_user, fn -> nil end)
    end
  end

  @doc """
  Used for routes that require the `PhoenixStarter.Users.User` to not be authenticated.
  """
  @spec redirect_if_user_is_authenticated(Plug.Conn.t(), any) :: Plug.Conn.t()
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the `PhoenixStarter.Users.User` to be authenticated.

  If you want to enforce the `PhoenixStarter.Users.User` email is confirmed before
  they use the application at all, here would be a good place.
  """
  @spec require_authenticated_user(Plug.Conn.t(), any) :: Plug.Conn.t()
  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
    else
      conn
      |> put_flash(:error, gettext("You must log in to access this page."))
      |> maybe_store_return_to()
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> halt()
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: "/"
end
