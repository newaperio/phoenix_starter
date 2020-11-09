defmodule PhoenixStarterWeb.LayoutViewTest do
  use PhoenixStarterWeb.ConnCase, async: true

  import Phoenix.HTML
  import PhoenixStarter.UsersFixtures

  alias PhoenixStarterWeb.LayoutView

  @base_class "border border-transparent rounded mb-5 p-4"
  @info_class "bg-blue-100 border-blue-200 text-blue-600"
  @warning_class "bg-yellow-100 border-yellow-200 text-yellow-700"
  @error_class "bg-red-200 border-red-300 text-red-800"

  test "alert/2 returns the correct HTML for a conn struct" do
    assert "info"
           |> conn_with_flash("info message")
           |> LayoutView.alert(:info)
           |> safe_to_string() ==
             ~s(<p class="#{@base_class} #{@info_class}" role="alert">info message</p>)

    assert "warning"
           |> conn_with_flash("warning message")
           |> LayoutView.alert(:warning)
           |> safe_to_string() ==
             ~s(<p class="#{@base_class} #{@warning_class}" role="alert">warning message</p>)

    assert "error"
           |> conn_with_flash("error message")
           |> LayoutView.alert(:error)
           |> safe_to_string() ==
             ~s(<p class="#{@base_class} #{@error_class}" role="alert">error message</p>)
  end

  test "alert/2 returns the correct HTML for a flash assign" do
    assert %{"info" => "info message"}
           |> LayoutView.alert(:info)
           |> safe_to_string() ==
             """
             <p class="#{@base_class} #{@info_class}"
                role="alert"
                phx-click="lv:clear-flash"
                phx-value-key="info"
             >
               info message
             </p>
             """

    assert %{"warning" => "warning message"}
           |> LayoutView.alert(:warning)
           |> safe_to_string() ==
             """
             <p class="#{@base_class} #{@warning_class}"
                role="alert"
                phx-click="lv:clear-flash"
                phx-value-key="warning"
             >
               warning message
             </p>
             """

    assert %{"error" => "error message"}
           |> LayoutView.alert(:error)
           |> safe_to_string() ==
             """
             <p class="#{@base_class} #{@error_class}"
                role="alert"
                phx-click="lv:clear-flash"
                phx-value-key="error"
             >
               error message
             </p>
             """
  end

  test "permitted?/2 returns a boolean" do
    current_user = user_fixture(%{role: :admin})

    assert LayoutView.permitted?(current_user, "me.update_profile")
    refute LayoutView.permitted?(current_user, "notareal.permission")
  end

  defp conn_with_flash(flash_key, msg) do
    :get
    |> build_conn("/")
    |> with_session()
    |> put_session("phoenix_flash", %{flash_key => msg})
    |> fetch_flash()
  end

  @session Plug.Session.init(
             store: :cookie,
             key: "_app",
             encryption_salt: "yadayada",
             signing_salt: "yadayada"
           )

  defp with_session(conn) do
    conn
    |> Map.put(:secret_key_base, String.duplicate("abcdefgh", 8))
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session()
  end
end
