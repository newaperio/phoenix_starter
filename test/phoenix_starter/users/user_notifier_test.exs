defmodule PhoenixStarter.Users.UserNotifierTest do
  use PhoenixStarter.DataCase

  import Swoosh.TestAssertions
  import PhoenixStarter.UsersFixtures

  alias PhoenixStarter.Users.UserNotifier

  setup do
    %{user: user_fixture()}
  end

  test "deliver_confirmation_instructions/2", %{user: user} do
    url = "http://example.com/confirm"

    UserNotifier.deliver_confirmation_instructions(user, url)

    assert_email_sent(
      subject: "Confirm your account",
      to: {"", user.email},
      text_body: ~r/#{url}/,
      html_body: ~r/#{url}/
    )
  end

  test "deliver_reset_password_instructions/2", %{user: user} do
    url = "http://example.com/reset"

    UserNotifier.deliver_reset_password_instructions(user, url)

    assert_email_sent(
      subject: "Reset your password",
      to: {"", user.email},
      text_body: ~r/#{url}/,
      html_body: ~r/#{url}/
    )
  end

  test "deliver_update_email_instructions/2", %{user: user} do
    url = "http://example.com/update"

    UserNotifier.deliver_update_email_instructions(user, url)

    assert_email_sent(
      subject: "Confirm email change",
      to: {"", user.email},
      text_body: ~r/#{url}/,
      html_body: ~r/#{url}/
    )
  end
end
