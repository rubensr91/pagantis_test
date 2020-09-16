defmodule Pagantis.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :amount, :integer
    field :iban, :string
    field :user_id, :id
    field :account_origin_id, :id

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:iban, :amount, :account_origin_id])
    |> validate_required([:iban, :amount, :account_origin_id])
  end

  def changeset_create_transaction(transaction, attrs, current_user, account) do
    transaction
    |> cast(attrs |> get_user_id(current_user) |> get_account_id(account), [:iban, :amount, :user_id, :account_origin_id])
    |> validate_required([:iban, :amount])
  end

  defp get_user_id(attrs, current_user) do
    attrs
    |> Map.put("user_id", current_user)
  end

  defp get_account_id(attrs, account) do
    attrs
    |> Map.put("account_origin_id", account.id)
  end
end
