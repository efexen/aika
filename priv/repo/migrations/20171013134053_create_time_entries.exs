defmodule Aika.Repo.Migrations.CreateTimeEntries do
  use Ecto.Migration

  def change do
    create table(:time_entries) do
      add :date, :date, null: false
      add :description, :text
      add :duration, :integer, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:time_entries, [:user_id])
  end
end
