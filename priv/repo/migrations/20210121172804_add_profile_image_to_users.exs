defmodule PhoenixStarter.Repo.Migrations.AddProfileImageToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add(:profile_image, :map, default: "[]")
    end
  end
end
