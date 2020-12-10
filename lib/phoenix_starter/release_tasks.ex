defmodule PhoenixStarter.ReleaseTasks do
  @app :phoenix_starter

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def migrations(repo) do
    load_app()
    {:ok, migrations, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.migrations(&1))
    migrations
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seeds do
    seeds_path = Application.app_dir(:phoenix_starter, "priv/repo/seeds.exs")

    if File.exists?(seeds_path) do
      Code.eval_file(seeds_path)
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
    Application.ensure_all_started(:ssl)
  end
end
