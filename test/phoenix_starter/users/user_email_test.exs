defmodule PhoenixStarter.Users.UserEmailTest do
  use PhoenixStarter.DataCase

  import PhoenixStarter.UsersFixtures

  alias PhoenixStarter.Users.UserEmail

  setup do
    %{user: user_fixture()}
  end

  test "confirmation_instructions/2", %{user: user} do
    url = "http://example.com/confirm"

    email = UserEmail.confirmation_instructions(user, url)

    assert email.to == [{"", user.email}]
    assert email.html_body =~ url
    assert email.text_body =~ url
  end

  test "reset_password_instructions/2", %{user: user} do
    url = "http://example.com/reset"

    email = UserEmail.reset_password_instructions(user, url)

    assert email.to == [{"", user.email}]
    assert email.html_body =~ url
    assert email.text_body =~ url
  end

  test "update_email_instructions/2", %{user: user} do
    url = "http://example.com/update"

    email = UserEmail.update_email_instructions(user, url)

    assert email.to == [{"", user.email}]
    assert email.html_body =~ url
    assert email.text_body =~ url
  end
end
