defmodule PhoenixStarterWeb.LayoutView do
  use PhoenixStarterWeb, :view

  alias Phoenix.HTML
  alias PhoenixStarter.Users

  @type flash_key() :: :info | :warning | :error

  @doc """
  Returns HTML for an alert banner based on a `%Plug.Conn{}` struct or a
  LiveView flash assign.

  The outermost tag is assigned a set of CSS utility `class`es that style the
  alert appropriately based on the given `flash_key`.
  """
  @spec alert(Plug.Conn.t() | map(), flash_key()) :: HTML.safe()
  def alert(%Plug.Conn{} = conn, flash_key) do
    case get_flash(conn, flash_key) do
      msg when is_binary(msg) ->
        content_tag(:p, msg, role: "alert", class: alert_class(flash_key))

      _ ->
        nil
    end
  end

  def alert(flash, flash_key) do
    case live_flash(flash, flash_key) do
      msg when is_binary(msg) -> lv_alert(flash_key, msg)
      _ -> nil
    end
  end

  @spec lv_alert(flash_key(), String.t()) :: HTML.safe()
  # sobelow_skip ["XSS.Raw"]
  defp lv_alert(flash_key, msg) do
    safe_msg =
      msg
      |> HTML.html_escape()
      |> safe_to_string()

    HTML.raw("""
    <p class="#{alert_class(flash_key)}"
       role="alert"
       phx-click="lv:clear-flash"
       phx-value-key="#{flash_key}"
    >
      #{safe_msg}
    </p>
    """)
  end

  @alert_class "border border-transparent rounded mb-5 p-4"

  @spec alert_class(flash_key()) :: String.t()
  defp alert_class(:info), do: @alert_class <> " bg-blue-100 border-blue-200 text-blue-600"

  defp alert_class(:warning),
    do: @alert_class <> " bg-yellow-100 border-yellow-200 text-yellow-700"

  defp alert_class(:error), do: @alert_class <> " bg-red-200 border-red-300 text-red-800"

  @spec permitted?(Users.User.t(), String.t()) :: boolean
  def permitted?(user, permission) do
    Users.permitted?(user, permission)
  end
end
