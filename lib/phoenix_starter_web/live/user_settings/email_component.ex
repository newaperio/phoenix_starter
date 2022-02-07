defmodule PhoenixStarterWeb.UserSettingsLive.EmailComponent do
  use PhoenixStarterWeb, :live_component

  alias PhoenixStarter.Users

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2>Update email</h2>

      <.form let={f} for={@changeset} id="form__update-email" phx-change="validate" phx-submit="save" phx-target={@myself}>
        <%= label f, :email %>
        <%= email_input f, :email, required: true, phx_debounce: "blur" %>
        <%= error_tag f, :email %>

        <%= label f, :current_password %>
        <%= password_input f, :current_password, name: "current_password", required: true, phx_debounce: "blur", value: @current_password %>
        <%= error_tag f, :current_password %>

        <%= submit "Update e-mail", phx_disable_with: "Saving..." %>
      </.form>
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
       |> assign(:changeset, Users.change_user_email(assigns.current_user))
       |> assign(:current_password, nil)}
    end
  end

  @impl true
  def handle_event(
        "validate",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    changeset =
      socket.assigns.current_user
      |> Users.change_user_email(current_password, user_params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(:current_password, current_password)
      |> assign(:changeset, changeset)

    send(
      self(),
      {:flash, :info, "A link to confirm your e-mail change has been sent to the new address."}
    )

    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "save",
        %{"current_password" => current_password, "user" => user_params},
        socket
      ) do
    case Users.apply_user_email(socket.assigns.current_user, current_password, user_params) do
      {:ok, applied_user} ->
        _ =
          Users.deliver_update_email_instructions(
            applied_user,
            socket.assigns.current_user.email,
            &Routes.user_settings_url(socket, :confirm_email, &1)
          )

        send(
          self(),
          {:flash, :info,
           "A link to confirm your e-mail change has been sent to the new address."}
        )

        {:noreply, assign(socket, :current_password, "")}

      {:error, changeset} ->
        socket =
          socket
          |> assign(:current_password, current_password)
          |> assign(:changeset, changeset)

        {:noreply, socket}
    end
  end
end
