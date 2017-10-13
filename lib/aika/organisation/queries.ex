defmodule Aika.Organisation.Queries do
  import Ecto.Query
  alias Aika.{Repo, User}

  def users(org) do
    query = from u in User, where: u.organisation_id == ^org.id
    Repo.all(query)
  end

  def remove_user(org, id) do
    user = Repo.get(User, id)

    if user.organisation_id == org.id do
      Repo.delete(user)
    end
  end

end
