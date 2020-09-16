defmodule Pagantis.Repo.Migrations.CreateBanks do
  use Ecto.Migration

  def change do
    create table(:banks) do
      add :name, :string
      add :bank_code, :string

      timestamps()
    end

  end
end
