defmodule Pagantis.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :amount, :integer
      add :iban, :string
      add :bank_id, :integer
      add :user_id, :integer

      timestamps()
    end

    create unique_index(:accounts, [:iban])
  end
end
