defmodule Aika.Timesheets.TimeEntry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aika.Timesheets.TimeEntry


  schema "time_entries" do
    field :date, :date
    field :description, :string
    field :duration, :integer

    belongs_to :user, Aika.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%TimeEntry{}, attrs)
  def changeset(%TimeEntry{} = time_entry, attrs) do
    time_entry
    |> cast(attrs, [:date, :description, :duration])
    |> validate_number(:duration, greater_than: 0, less_than: 1440)
    |> validate_required([:date, :description, :duration])
    |> put_assoc(:user, attrs.user)
  end
end
