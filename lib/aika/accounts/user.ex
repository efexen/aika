defmodule Aika.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aika.Accounts.User

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :role, :integer
    field :password, :string, virtual: true
    field :token, :string

    belongs_to :organisation, Aika.Accounts.Organisation
    has_many :time_entries, Aika.Timesheets.TimeEntry

    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%User{}, attrs)
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :role, :password, :token])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: 8)
    |> hash_password()
    |> put_assoc(:organisation, attrs.organisation)
    |> unique_constraint(:email)
  end

  def password_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:password, :token])
    |> validate_required([:password])
    |> validate_length(:password, min: 8)
    |> hash_password()
  end

  defp hash_password(changeset) do
    digest = get_change(changeset, :password) |> Bcrypt.hash_pwd_salt
    put_change(changeset, :password_digest, digest)
  end

end
