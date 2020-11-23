# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PhoenixStarter.Repo.insert!(%PhoenixStarter.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PhoenixStarter.Repo
alias PhoenixStarter.Users

valid_password = "password1234"

defmodule SeedHelpers do
  def confirm_user({:ok, user} = result) do
    user |> Users.User.confirm_changeset() |> Repo.update!()
    result
  end

  def confirm_user(result), do: result
end

{:ok, _} =
  %{
    email: "ops_admin@example.com",
    password: valid_password,
    role: :ops_admin
  }
  |> Users.register_user()
  |> SeedHelpers.confirm_user()

for i <- 0..9 do
  {:ok, _} =
    %{email: "admin_#{i}@example.com", password: valid_password, role: :admin}
    |> Users.register_user()
    |> SeedHelpers.confirm_user()
end

for i <- 0..9 do
  {:ok, _} =
    %{email: "user_#{i}@example.com", password: valid_password, role: :user}
    |> Users.register_user()
    |> SeedHelpers.confirm_user()
end
