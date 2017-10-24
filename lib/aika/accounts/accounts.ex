defmodule Aika.Accounts do

  alias Aika.Accounts.{User, Registration}
  alias Aika.Timesheets.TimeEntry
  alias Aika.Timesheets.Queries, as: TimesheetsQueries
  alias Aika.Repo

  def create_admin(params) do
    Registration.create_new(params)
  end

  def create_invite(org, email) do
    Registration.invite(org, email)
  end

  def set_password(user, password) do
    Registration.set_password(user, password)
  end

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

  def users_for_invite(invite) do
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
    org = Repo.preload(org, :users)
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

end
