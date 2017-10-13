defmodule Aika.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false, unique: true
      add :password_digest, :string
      add :role, :integer, null: false, default: 0
      add :organisation_id, references(:organisations, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:users, [:organisation_id])
  end
end
