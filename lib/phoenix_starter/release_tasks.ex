defmodule PhoenixStarter.ReleaseTasks do
  @moduledoc """
  Server tasks to be run inside the production release container.
  """
  @app :phoenix_starter

  require Logger

  @spec migrate :: [any]
  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  @spec migrations :: [any]
  def migrations do
    load_app()

    for repo <- repos() do
      {:ok, migrations, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.migrations(&1))
      migrations |> format_migrations(repo) |> Logger.info()
    end
  end

  @spec rollback :: [any]
  def rollback do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, step: 1))
    end
  end

  @spec seeds :: [any]
  def seeds do
    load_app()

    for repo <- repos() do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, fn _ ->
          seeds_path = Ecto.Migrator.migrations_path(repo, "/seeds.ex")

          if File.exists?(seeds_path) do
            Code.eval_file(seeds_path)
          end
        end)
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
    Application.ensure_all_started(:ssl)
  end

  defp format_migrations(migrations, repo) do
    # Borrowed from mix ecto.migrations
    """

    Repo: #{inspect(repo)}

      Status    Migration ID    Migration Name
    --------------------------------------------------
    """ <>
      Enum.map_join(migrations, "\n", fn {status, number, description} ->
        "  #{format(status, 10)}#{format(number, 16)}#{description}"
      end)
  end

  defp format(content, pad) do
    content
    |> to_string
    |> String.pad_trailing(pad)
  end
end
