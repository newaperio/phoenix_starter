defmodule PhoenixStarter.Workers.UserEmailWorker do
  @moduledoc """
  Schedules an email from `PhoenixStarter.Users.UserEmail` to be sent.
  """
  use Oban.Worker, queue: :emails, tags: ["email", "user-email"]

  alias PhoenixStarter.Users
  alias PhoenixStarter.Users.UserEmail
  alias PhoenixStarter.Mailer

  @impl true
  @spec perform(Oban.Job.t()) :: Oban.Worker.result()
  def perform(%Oban.Job{args: %{"email" => email} = args}) do
    if email in emails() do
      perform_email(args)
    else
      {:discard, :invalid_email}
    end
  end

  defp emails do
    :functions
    |> UserEmail.__info__()
    |> Keyword.keys()
    |> Enum.reject(fn f -> f == :render end)
    |> Enum.map(&Atom.to_string/1)
  end

  defp perform_email(args) do
    {email, args} = Map.pop(args, "email")

    %{"user_id" => user_id, "url" => url} = args
    user = Users.get_user!(user_id)

    email = apply(UserEmail, String.to_existing_atom(email), [user, url])
    Mailer.deliver(email)
    {:ok, email}
  end

  defimpl PhoenixStarter.Workers.Reportable do
    @threshold 3

    @spec reportable?(Oban.Worker.t(), integer) :: boolean
    def reportable?(_worker, attempt), do: attempt > @threshold
  end
end
