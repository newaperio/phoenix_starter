defmodule PhoenixStarter.Workers.UserEmailWorkerTest do
  use PhoenixStarter.DataCase

  import PhoenixStarter.UsersFixtures

  alias PhoenixStarter.Workers.UserEmailWorker

  test "sends email" do
    user = user_fixture()

    assert {:ok, _} =
             UserEmailWorker.perform(%Oban.Job{
               args: %{
                 "email" => "confirmation_instructions",
                 "user_id" => user.id,
                 "url" => "https://example.com"
               }
             })
  end

  test "discards job if email isn't available" do
    assert {:discard, :invalid_email} =
             UserEmailWorker.perform(%Oban.Job{args: %{"email" => "foobar"}})
  end
end
