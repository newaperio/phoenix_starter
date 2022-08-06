defmodule PhoenixStarterWeb.TemplateHelpersTest do
  use PhoenixStarter.DataCase

  alias PhoenixStarterWeb.TemplateHelpers

  describe "format_timestamp/2" do
    setup do
      timestamp = ~U[2019-03-06 23:13:00Z]
      %{timestamp: timestamp}
    end

    test "short", %{timestamp: timestamp} do
      assert TemplateHelpers.format_timestamp(timestamp, :short) == "Mar. 06, 2019"
    end

    test "date_and_time", %{timestamp: timestamp} do
      assert TemplateHelpers.format_timestamp(timestamp, :date_and_time) == "Mar. 06 @ 11:13pm"
    end
  end
end
