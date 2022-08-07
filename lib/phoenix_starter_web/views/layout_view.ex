defmodule PhoenixStarterWeb.LayoutView do
  use PhoenixStarterWeb, :view
  use Phoenix.Component

  alias PhoenixStarter.Users

  @type flash_key() :: :success | :notice | :error

  @doc """
  Renders a flash message.

  The rendered flash receives a `:type` that will be used to define
  proper classes to the element, and a `:message` which will be the
  inner HTML, if any exists.

  ## Examples

      <.flash flash={@flash} kind={:info} />

  """
  def flash(assigns) do
    assigns = assign(assigns, :message, Map.get(assigns.flash, Atom.to_string(assigns.kind)))

    ~H"""
    <%= if @message do %>
      <div class={alert_class(@kind)} role="alert" phx-click="lv:clear-flash" phx-value-key={@kind}>
        <p class="flex-grow"><.alert_prefix kind={@kind} /> <%= @message %></p>
        <span class="cursor-pointer">&times;</span>
      </div>
    <% end %>
    """
  end

  @alert_class "flex border border-transparent rounded mb-5 p-4"

  @spec alert_class(flash_key()) :: String.t()
  defp alert_class(:success), do: @alert_class <> " bg-green-100 border-green-200 text-green-600"

  defp alert_class(:notice),
    do: @alert_class <> " bg-yellow-100 border-yellow-200 text-yellow-700"

  defp alert_class(:error), do: @alert_class <> " bg-red-200 border-red-300 text-red-800"

  @spec alert_prefix(%{kind: flash_key()}) :: String.t()
  defp alert_prefix(%{kind: :success} = assigns) do
    ~H"""
    <span class="font-bold text-green-800">Success!</span>
    """
  end

  defp alert_prefix(%{kind: :notice} = assigns) do
    ~H"""
    <span class="font-bold text-yellow-800">Notice:</span>
    """
  end

  defp alert_prefix(%{kind: :error} = assigns) do
    ~H"""
    <span class="font-bold text-red-800">Error:</span>
    """
  end

  @spec permitted?(Users.User.t(), String.t()) :: boolean
  def permitted?(user, permission) do
    Users.permitted?(user, permission)
  end
end
