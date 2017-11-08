defmodule Aika.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, null: false
      add :organisation_id, references(:organisations, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:categories, [:organisation_id])
  end
end
