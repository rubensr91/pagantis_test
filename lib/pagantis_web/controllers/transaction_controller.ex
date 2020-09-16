defmodule PagantisWeb.TransactionController do
  use PagantisWeb, :controller

  alias Pagantis.Transactions
  alias Pagantis.Transactions.Transaction
  alias Pagantis.Accounts
  alias Pagantis.Accounts.Account

  def index(conn, _params) do
    transactions = Transactions.list_transactions(conn.assigns.current_user.id)
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, params) do
    changeset = Transactions.change_transaction(%Transaction{}, params)
    render(conn, "new.html", changeset: changeset, account: params["account_id"])
  end

  def create(conn, %{"transaction" => params}) do
    account_origin = Accounts.get_account!(params["account_id"])
    account_destiny = Accounts.get_account_by_iban(params["iban"])

    current_user = conn.assigns.current_user.id

    IO.puts "::::::::: account_origin #{inspect account_origin}"
    IO.puts "::::::::: params #{inspect params}"

    {amount_to_send, ""} = Integer.parse params["amount"] 

    has_enough_money = account_origin.amount - amount_to_send

    case has_enough_money < 0 do
      true ->
        conn
        |> put_flash(:error, "Transaction not done. You don't have enough money")
        |> redirect(to: Routes.transaction_path(conn, :index))
      _->
        case account_destiny do
          %Account{} ->
            case Transactions.create_transaction(params, current_user, account_destiny) do
              {:ok, transaction} ->
    
                same_bank_or_not = Account.check_bank_accounts(account_origin, account_destiny)
    
                case Accounts.update_account_destiny(account_destiny, params, same_bank_or_not) do
                  {:ok, account} ->
                    Accounts.update_account_origin(account_origin, params)
                    
                    conn
                    |> put_flash(:info, "Transaction done successfully.")
                    |> redirect(to: Routes.transaction_path(conn, :index))
                  _->
                    conn
                    |> put_flash(:error, "Transaction not done.")
                    |> redirect(to: Routes.transaction_path(conn, :index))
                end
              {:error, %Ecto.Changeset{} = changeset} ->
                render(conn, "new.html", changeset: changeset)
            end
           _->
            conn
            |> put_flash(:error, "Transaction not created because the IBAN doesn't exits.")
            |> redirect(to: Routes.transaction_path(conn, :index))
        end
    end
  end

  def show(conn, account) do
    current_user = conn.assigns.current_user

    transactions = Transactions.list_transactions(current_user.id, account["iban"])
    render(conn, "index.html", transactions: transactions)
  end

  def edit(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    changeset = Transactions.change_transaction(transaction)
    render(conn, "edit.html", transaction: transaction, changeset: changeset)
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Transactions.get_transaction!(id)

    case Transactions.update_transaction(transaction, transaction_params) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: Routes.transaction_path(conn, :show, transaction))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", transaction: transaction, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _transaction} = Transactions.delete_transaction(transaction)

    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: Routes.transaction_path(conn, :index))
  end
end
