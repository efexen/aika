defmodule Aika.User.Queries do
  import Ecto.Query

  alias Aika.{User, Repo, Organisation, TimeEntry}

  def user_with_organisation(nil), do: {:error, nil}
  def user_with_organisation(id) do
    Repo.get(User, id)
    |> Repo.preload(:organisation)
  end

  def id_for_email_and_password(email, password) do
    with %{id: user_id, password_digest: password_digest } <- Repo.get_by(User, email: email),
          true <- Bcrypt.verify_pass(password, password_digest) do
            {:ok, user_id}
    else
      _ -> {:error, "No match"}
    end
  end

  def for_invite(invite) do
    Repo.get_by(User, token: invite)
    |> Repo.preload(:organisation)
  end

  def user_show(organisation, id, start_date, end_date) do
    query = from u in User,
            where: u.organisation_id == ^organisation.id and u.id == ^id
    Repo.one(query)
    |> Repo.preload(time_entries: from(te in TimeEntry,
        where: te.date >= ^start_date and te.date <= ^end_date
      ))
  end

end
