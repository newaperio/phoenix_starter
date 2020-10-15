defmodule PhoenixStarter.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_starter,
    adapter: Ecto.Adapters.Postgres

  @typedoc """
  Represents what can be expected as the result of an Ecto operation on a
  changeset.
  """
  @type result() ::
          {:ok, Ecto.Schema.t()}
          | {:ok, %{required(Ecto.Multi.name()) => Ecto.Schema.t()}}
          | {:error, Ecto.Changeset.t()}
          | {:error, Ecto.Multi.name(), any(), %{required(Ecto.Multi.name()) => any()}}
end
