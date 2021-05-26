defmodule PhoenixStarterWeb.UserSettingsLive.Index do
  use PhoenixStarterWeb, :live_view

  @impl true
  def mount(params, session, socket) do
    socket = assign_defaults(socket, params, session)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :profile, _params) do
    assign(socket, :page_title, "Update Profile")
  end

  defp apply_action(socket, :email, _params) do
    assign(socket, :page_title, "Update Email")
  end

  defp apply_action(socket, :password, _params) do
    assign(socket, :page_title, "Update Password")
  end

  @impl true
  def handle_info({:flash, key, message}, socket) do
    {:noreply, put_flash(socket, key, message)}
  end
end
