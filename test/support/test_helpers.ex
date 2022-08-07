defmodule PhoenixStarterWeb.TestHelpers do
  import ExUnit.Assertions, only: [assert: 2]

  def assert_text_in_html(html, text) do
    assert Floki.text(html) =~ text, "expected to find '#{text}' in #{html}"
  end
end
