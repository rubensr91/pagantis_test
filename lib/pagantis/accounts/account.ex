defmodule Pagantis.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :amount, :integer
    field :iban, :string, not_null: false
    field :bank_id, :integer
    field :user_id, :integer

    timestamps()
  end

  def check_bank_accounts(account_origin, account_destiny) do
    case account_origin.bank_id == account_destiny.bank_id do
      true ->
        {:ok, true}
      _->
        {:ok, false}
    end
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:amount, :iban])
  end

  def changeset_update_account_destiny(account, attrs, same_bank_or_not) do
    account
    |> cast(attrs |> generate_new_amount_destiny(account, same_bank_or_not), [:amount, :iban])
  end

  def changeset_update_account_origin(account, attrs) do
    account
    |> cast(attrs |> generate_new_amount_origin(account), [:amount])
  end

  def changeset_create_account(account, attrs, current_user) do
    account
    |> cast(attrs |> generate_iban |> get_user_id(current_user), [:amount, :iban, :bank_id, :user_id])
    |> validate_required([:amount, :iban])
  end

  defp generate_new_amount_destiny(attrs, account, same_bank_or_not) do
    {transaction_amount, ""} = Integer.parse(attrs["amount"])
    taxes = transaction_amount * 0.3
    account_plus_taxes = account.amount + transaction_amount - taxes

    case same_bank_or_not do
      {:ok, true} ->
        attrs
        |> Map.put("amount", account.amount + transaction_amount)
      _ ->
        attrs
        |> Map.put("amount", trunc(account_plus_taxes))
    end

  end

  defp generate_new_amount_origin(attrs, account) do
    {transaction_amount, ""} = Integer.parse(attrs["amount"])
    attrs
    |> Map.put("amount", account.amount - transaction_amount)
  end

  defp generate_iban(attrs) do
    random_number = to_string("ES#{Enum.random(1111111..9999999)}")

    attrs
    |> Map.put("iban", random_number)
  end

  defp get_user_id(attrs, current_user) do
    attrs
    |> Map.put("user_id", current_user.id)
  end
end
