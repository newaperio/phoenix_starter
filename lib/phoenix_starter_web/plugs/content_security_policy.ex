defmodule PhoenixStarterWeb.ContentSecurityPolicy do
  @moduledoc """
  This `Plug` adds a `Content-Security-Policy` HTTP header to responses.

  The configured policy are the defaults necessary for the configured stack
  included in PhoenixStarter, but can be customized based on application
  needs.
  """

  import Phoenix.Controller, only: [put_secure_browser_headers: 2]

  def init(opts), do: opts

  def call(conn, _) do
    directives = [
      "default-src #{default_src_directive()}",
      "form-action #{form_action_directive()}",
      "media-src #{media_src_directive()}",
      "img-src #{image_src_directive()}",
      "script-src #{script_src_directive()}",
      "font-src #{font_src_directive()}",
      "connect-src #{connect_src_directive()}",
      "style-src #{style_src_directive()}",
      "frame-src #{frame_src_directive()}"
    ]

    put_secure_browser_headers(conn, %{"content-security-policy" => Enum.join(directives, "; ")})
  end

  defp default_src_directive, do: "'none'"
  defp form_action_directive, do: "'self'"
  defp media_src_directive, do: "'self'"
  defp font_src_directive, do: "'self' data:"

  defp connect_src_directive do
    "'self' #{app_host("ws://*.")} #{app_host("wss://*.")} #{upload_host()}"
  end

  defp style_src_directive, do: "'self' 'unsafe-inline'"
  defp frame_src_directive, do: "'self'"

  defp image_src_directive do
    "'self' data: #{upload_host()}"
  end

  defp script_src_directive do
    # Webpack HMR needs unsafe-inline (dev only)
    # Alpine needs unsafe-eval
    if Keyword.get(config(), :allow_unsafe_inline, false) do
      "'self' 'unsafe-eval' 'unsafe-inline'"
    else
      "'self' 'unsafe-eval'"
    end
  end

  defp config do
    Application.get_env(:phoenix_starter, __MODULE__, [])
  end

  defp app_host(prefix) do
    case Keyword.get(config(), :app_host) do
      host when is_binary(host) ->
        prefix <> host

      _ ->
        ""
    end
  end

  defp upload_host(prefix \\ "https://") do
    bucket_name =
      :phoenix_starter
      |> Application.get_env(PhoenixStarter.Uploads, [])
      |> Keyword.get(:bucket_name)

    "#{prefix}#{bucket_name}.s3.amazonaws.com"
  end
end
