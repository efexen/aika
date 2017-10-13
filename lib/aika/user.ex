defmodule Aika.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aika.User

  schema "users" do
    field :email, :string
    field :password_digest, :string
    field :role, :integer
    field :password, :string, virtual: true
    field :token, :string

    belongs_to :organisation, Aika.Organisation
    has_many :time_entries, Aika.TimeEntry

    timestamps()
  end

  @doc false
  def changeset(attrs), do: changeset(%User{}, attrs)
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :role, :password, :token])
    |> validate_required([:email, :password, :role])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> hash_password()
    |> put_assoc(:organisation, attrs.organisation)
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
