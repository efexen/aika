defmodule Aika.Timesheets.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aika.Timesheets.Category


  schema "categories" do
    field :name, :string

    belongs_to :organisation, Aika.Accounts.Organisation

    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%Category{}, attrs)
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> put_assoc(:organisation, attrs.organisation)
  end
end
