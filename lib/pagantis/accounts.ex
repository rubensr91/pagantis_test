defmodule Pagantis.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Pagantis.Repo

  alias Pagantis.Accounts.Account

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts(user_id) do
    query = from(account in Account, where: ^user_id == account.user_id)
    Repo.all(query)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  def get_account_by_iban(iban), do: Repo.get_by(Account, iban: iban)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}, current_user) do
    %Account{}
    |> Account.changeset_create_account(attrs, current_user)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account_destiny(%Account{} = account, attrs, same_bank_or_not) do
    account
    |> Account.changeset_update_account_destiny(attrs, same_bank_or_not)
    |> IO.inspect
    |> Repo.update()
  end

  def update_account_origin(%Account{} = account, attrs) do
    account
    |> Account.changeset_update_account_origin(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  def check_bank_accounts(%Account{} = account_origin, %Account{} = account_destiny) do
    Account.check_bank_accounts(account_origin, account_destiny)
  end
end
