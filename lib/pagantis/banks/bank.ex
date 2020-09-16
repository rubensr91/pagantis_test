defmodule Pagantis.Banks.Bank do
  use Ecto.Schema
  import Ecto.Changeset

  schema "banks" do
    field :name, :string
    field :bank_code, :string

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
