defmodule PhoenixStarter.EmailTest do
  use PhoenixStarter.DataCase

  alias PhoenixStarter.Email

  test "default_from/0 returns formatted address" do
    assert Email.default_from() == {"PhoenixStarter", "notifications@example.com"}
  end
end
