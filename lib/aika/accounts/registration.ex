defmodule Aika.Accounts.Registration do

  alias Aika.Repo
  alias Aika.Accounts.{Organisation, User}

  def create_new(params) do
    case create_organisation(params["org_name"]) do
      {:ok, org} ->
        create_admin_user(params, org)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def invite(org, email) do
    User.changeset(%{
      email: email,
      password: Ecto.UUID.generate(),
      token: Ecto.UUID.generate(),
      organisation: org,
      role: 0
    }) |> Repo.insert()
  end

  def set_password(user, password) do
    user
    |> User.password_changeset(%{ password: password, token: nil })
    |> Repo.update()
  end

  defp create_admin_user(%{ "email" => email, "password" => password }, org) do
    User.changeset(%{
      email: email,
      password: password,
      organisation: org,
      role: 1
    }) |> Repo.insert()
  end

  defp create_organisation(name) do
    Organisation.changeset(%{name: name})
    |> Repo.insert()
  end

end
