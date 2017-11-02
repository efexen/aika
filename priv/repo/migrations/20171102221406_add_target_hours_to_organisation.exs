defmodule Aika.Repo.Migrations.AddTargetHoursToOrganisation do
  use Ecto.Migration

  def change do
    alter table(:organisations) do
      add :target_hours, :integer, null: false, default: 450
    end
  end
end
