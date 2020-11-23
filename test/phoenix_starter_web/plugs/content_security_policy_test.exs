defmodule PhoenixStarterWeb.ContentSecurityPolicyTest do
  use PhoenixStarterWeb.ConnCase

  test "adds content-security-policy header" do
    conn =
      build_conn()
      |> bypass_through(PhoenixStarterWeb.Router, [:browser])
      |> get("/")

    header = get_resp_header(conn, "content-security-policy")

    assert is_list(header)
    assert length(header) == 1
  end
end
