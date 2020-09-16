defmodule PagantisWeb.AccountController do
  use PagantisWeb, :controller

  alias Pagantis.Accounts
  alias Pagantis.Accounts.Account
  alias Pagantis.Banks
  alias Pagantis.Banks.Bank
  alias Pagantis.Repo

  import Ecto.Query

  def index(conn, _params) do
    accounts = Accounts.list_accounts(conn.assigns.current_user.id)
    render(conn, "index.html", accounts: accounts)
  end

  def new(conn, _params) do
    query = from(bank in Banks.Bank, select: {bank.name, bank.id})
    banks = Repo.all(query)

    changeset = Accounts.change_account(%Account{})
    render(conn, "new.html", changeset: changeset, banks: banks)
  end

  def create(conn, %{"account" => account_params}) do
    query = from(bank in Banks.Bank, select: {bank.name, bank.id})
    banks = Repo.all(query)
    current_user = conn.assigns.current_user

    case Accounts.create_account(account_params, current_user) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, banks: banks)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    bank = Banks.get_bank!(account.bank_id)

    render(conn, "show.html", account: account, bank: bank)
  end

  def edit(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    changeset = Accounts.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

    case Accounts.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    {:ok, _account} = Accounts.delete_account(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: Routes.account_path(conn, :index))
  end
end
