defmodule Pagantis.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :password_hash, :string
      add :date, :date
      add :name, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
