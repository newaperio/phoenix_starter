defmodule PhoenixStarterWeb.UserSettingsLive.ProfileComponentTest do
  use PhoenixStarterWeb.ConnCase

  import Phoenix.LiveViewTest

  @form_id "#form__update-profile"

  setup :register_and_log_in_user

  test "validates", %{conn: conn} do
    {:ok, live, _html} = live(conn, Routes.user_settings_path(conn, :profile))

    profile_image =
      file_input(live, @form_id, :profile_image, [
        %{
          last_modified: 1_551_913_980,
          name: "profile-image.jpg",
          content: File.read!("./test/support/profile-image.jpg"),
          size: 100 * 1024 * 1024,
          type: "image/gif"
        }
      ])

    assert {:error, [[_, :too_large]]} = preflight_upload(profile_image)

    assert live
           |> form(@form_id, user: %{})
           |> render_change(profile_image) =~ "must be smaller than 25mb"

    profile_image =
      file_input(live, @form_id, :profile_image, [
        %{
          last_modified: 1_551_913_980,
          name: "profile-image.jpg",
          content: File.read!("./test/support/profile-image.jpg"),
          size: 2_169_900,
          type: "image/jpeg"
        }
      ])

    assert {:ok, %{ref: _ref, config: %{chunk_size: _}}} = preflight_upload(profile_image)
  end

  test "saves", %{conn: conn} do
    {:ok, live, _html} = live(conn, Routes.user_settings_path(conn, :profile))

    profile_image =
      file_input(live, @form_id, :profile_image, [
        %{
          last_modified: 1_551_913_980,
          name: "profile-image.jpg",
          content: File.read!("./test/support/profile-image.jpg"),
          size: 2_169_900,
          type: "image/jpeg"
        }
      ])

    assert live
           |> form(@form_id, user: %{})
           |> render_change(profile_image) =~ "profile-image.jpg - 0%"

    assert render_upload(profile_image, "profile-image.jpg") =~ "100%"
  end
end
