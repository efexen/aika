defmodule Aika.Accounts do
  import Ecto.Query, warn: false

  alias Aika.Accounts.{User, Registration}
  alias Aika.Timesheets.TimeEntry
  alias Aika.Timesheets.Queries, as: TimesheetsQueries
  alias Aika.Repo

  defdelegate create_admin(params), to: Registration, as: :create_new
  defdelegate create_invite(org, email), to: Registration, as: :invite
  defdelegate set_password(user, password), to: Registration

  def user_with_organisation(nil), do: {:error, nil}
  def user_with_organisation(id) do
    User
    |> Repo.get(id)
    |> Repo.preload(:organisation)
  end

  def id_for_email_and_password(email, password) do
    with  %{id: user_id, password_digest: password_digest } <- Repo.get_by(User, email: email),
          true <- Bcrypt.verify_pass(password, password_digest)
    do
      {:ok, user_id}
    else
      _ -> {:error, "No match"}
    end
  end

  def user_for_invite(invite) do
    User
    |> Repo.get_by(token: invite)
    |> Repo.preload(:organisation)
  end

  def user_show(organisation, id, start_date, end_date) do
    User
    |> Repo.get_by(id: id, organisation_id: organisation.id)
    |> Repo.preload(time_entries: TimesheetsQueries.time_entries_between(TimeEntry, start_date, end_date))
  end

  def users(org) do
    user_query = from u in User, order_by: u.email
    org = Repo.preload(org, users: user_query)
    org.users
  end

  def remove_user(org, id) do
    user = Repo.get(User, id)

    if user.organisation_id == org.id do
      Repo.delete(user)
    end
  end

  def set_admin(org, id) do
    user = Repo.get(User, id)

    if user.organisation_id == org.id do
      user
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_change(:role, 1)
      |> Repo.update!
    end
  end

  def create_api_token!(user) do
    user
    |> User.api_token_changeset()
    |> Repo.update()
  end
end
