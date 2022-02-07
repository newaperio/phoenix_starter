defmodule PhoenixStarterWeb.UserSettingsLive.ProfileComponent do
  use PhoenixStarterWeb, :live_component

  alias PhoenixStarter.Uploads
  alias PhoenixStarter.Users

  @upload_limit 25 * 1024 * 1024

  @impl true
  def mount(socket) do
    socket =
      allow_upload(socket, :profile_image,
        accept: ~w(.jpg .jpeg .png),
        external: &presign_upload/2,
        max_file_size: @upload_limit
      )

    {:ok, socket}
  end

  @impl true
  def update(assigns, socket) do
    if socket.assigns[:current_user] do
      {:ok, socket}
    else
      {:ok,
       socket
       |> assign(:current_user, assigns.current_user)
       |> assign(:current_image, assigns.current_user.profile_image)
       |> assign(:changeset, Users.change_user_profile(assigns.current_user))}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2>Update profile</h2>

      <.form for={@changeset} id="form__update-profile" phx-change="validate" phx-submit="save" phx-target={@myself}>
        <h2>Profile Photo</h2>

        <div>
          Current Image:
          <%= img_tag Uploads.upload_url(@current_image), width: 75 %>
        </div>

        <%= live_file_input @uploads.profile_image %>
        <%= for entry <- @uploads.profile_image.entries do %>
          Selected Image:
          <%= live_img_preview entry, width: 75 %>
          <%= entry.client_name %> - <%= entry.progress %>%
          <%= for err <- upload_errors(@uploads.profile_image, entry) do %>
            <p><%= upload_error(err) %></p>
          <% end %>
        <% end %>

        <%= submit "Update profile", phx_disable_with: "Saving..." %>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", _params, socket) do
    changeset =
      socket.assigns.current_user
      |> Users.change_user_profile(%{})
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    [uploaded_file] =
      consume_uploaded_entries(socket, :profile_image, fn params, entry ->
        %{
          "variation" => "source",
          "key" => params.fields.key,
          "last_modified" => entry.client_last_modified,
          "name" => entry.client_name,
          "size" => entry.client_size,
          "type" => entry.client_type
        }
      end)

    case Users.update_user_profile(socket.assigns.current_user, %{
           "profile_image" => [uploaded_file]
         }) do
      {:ok, user} ->
        send(
          self(),
          {:flash, :info, "Profile updated succcessfully."}
        )

        {:noreply, assign(socket, :current_image, user.profile_image)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp presign_upload(entry, socket) do
    current_user = socket.assigns.current_user
    prefix = "profile-images/#{current_user.id}"
    {:ok, upload} = Uploads.create_upload(entry, prefix: prefix, upload_limit: @upload_limit)

    meta = Map.put(upload, :uploader, "S3")
    {:ok, meta, socket}
  end

  defp upload_error(:too_large), do: "must be smaller than 25mb"
  defp upload_error(:too_many_files), do: "must be one file"
  defp upload_error(:not_accepted), do: "must be .jpg or .png"
end
