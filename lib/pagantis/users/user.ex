defmodule Pagantis.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    field :date, :date
    field :name, :string

    timestamps()
  end

  #TODO I've to add the validation with Customer table 
  # def changeset(user_or_changeset, attrs) do
  #   user_or_changeset
  #   |> pow_changeset(attrs)
  #   |> Ecto.Changeset.cast(attrs, [:custom])
  #   |> Ecto.Changeset.validate_required([:custom])
  # end
end
