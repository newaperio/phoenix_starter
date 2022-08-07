defmodule PhoenixStarterWeb.LayoutViewTest do
  use PhoenixStarterWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import PhoenixStarter.UsersFixtures

  alias PhoenixStarterWeb.LayoutView

  describe "flash/1" do
    test "renders success" do
      flash = %{"success" => "Test message."}

      rendered = render_component(&LayoutView.flash/1, flash: flash, kind: :success)

      assert_text_in_html(rendered, "Success! Test message.")
    end

    test "renders notice" do
      flash = %{"notice" => "Test message."}

      rendered = render_component(&LayoutView.flash/1, flash: flash, kind: :notice)

      assert_text_in_html(rendered, "Notice: Test message.")
    end

    test "renders error" do
      flash = %{"error" => "Test message."}

      rendered = render_component(&LayoutView.flash/1, flash: flash, kind: :error)

      assert_text_in_html(rendered, "Error: Test message.")
    end

    test "renders nothing if no flash" do
      flash = %{"success" => "Test message."}

      assert render_component(&LayoutView.flash/1, flash: flash, kind: :error) == ""
    end
  end

  test "permitted?/2 returns a boolean" do
    current_user = user_fixture(%{role: :admin})

    assert LayoutView.permitted?(current_user, "me.update_profile")
    refute LayoutView.permitted?(current_user, "notareal.permission")
  end
end
