defmodule Aika.Accounts.Organisation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aika.Accounts.Organisation

  schema "organisations" do
    field :name, :string
    field :target_hours, :integer

    has_many :users, Aika.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%Organisation{}, attrs)
  def changeset(%Organisation{} = organisation, attrs) do
    organisation
    |> cast(attrs, [:name, :target_hours])
    |> validate_required([:name])
  end

end
