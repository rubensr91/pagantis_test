defmodule Pagantis.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :iban, :string
      add :amount, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :account_origin_id, references(:accounts, on_delete: :nothing)

      timestamps()
    end
  end
end
