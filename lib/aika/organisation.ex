defmodule Aika.Organisation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aika.Organisation

  schema "organisations" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%Organisation{}, attrs)
  def changeset(%Organisation{} = organisation, attrs) do
    organisation
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
