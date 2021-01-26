defmodule PhoenixStarterWeb.UserSettingsLive.PasswordComponent do
  use PhoenixStarterWeb, :live_component

  alias PhoenixStarter.Users

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <h2>Update password</h2>

      <%= f = form_for @changeset, Routes.user_settings_path(@socket, :update_password),
        id: "form__update-password",
        phx_change: "validate",
        phx_submit: "update",
        phx_trigger_action: @trigger_action,
        phx_target: @myself %>

        <%= label f, :password, "New password" %>
        <%= password_input f, :password, required: true, value: input_value(f, :password), phx_debounce: "blur" %>
        <%= error_tag f, :password %>

        <%= label f, :password_confirmation, "Confirm new password" %>
        <%= password_input f, :password_confirmation, value: input_value(f, :password_confirmation), required: true, phx_debounce: "blur" %>
        <%= error_tag f, :password_confirmation %>

        <%= label f, :current_password %>
        <%= password_input f, :current_password, name: "current_password", required: true, phx_debounce: "blur", value: @current_password %>
        <%= error_tag f, :current_password %>

        <%= submit "Change password", phx_disable_with: "Saving..." %>
      </form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    if socket.assigns[:current_user] do
      {:ok, socket}
    else
      {:ok,
       socket
       |> assign(:current_user, assigns.current_user)
       |> assign(:changeset, Users.change_user_password(assigns.current_user))
       |> assign(:current_password, nil)
       |> assign(:trigger_action, false)}
    end
  end

  @impl true
  def handle_event(
        "validate",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    changeset =
      Users.change_user_password(socket.assigns.current_user, current_password, user_params)

    socket =
      socket
      |> assign(:current_password, current_password)
      |> assign(:changeset, changeset)

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "update",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    socket = assign(socket, :current_password, current_password)

    socket.assigns.current_user
    |> Users.apply_user_password(current_password, user_params)
    |> case do
      {:ok, _} ->
        {:noreply, assign(socket, :trigger_action, true)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
