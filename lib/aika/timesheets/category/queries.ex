defmodule Aika.Timesheets.Category.Queries do
  import Ecto.Query, warn: false

  alias Aika.Timesheets.Category
  alias Aika.Repo

  def categories_for(org) do
    query = from c in Category, where: c.organisation_id == ^org.id
    Repo.all(query)
  end

  def create_for(org, name) do
    Category.changeset(%{name: name, organisation: org})
    |> Repo.insert
  end

  def remove_for(org, id) do
    query = from c in Category, where: c.organisation_id == ^org.id and c.id == ^id
    Repo.delete_all(query)
  end

end
