defmodule Aika.User.Queries do

  alias Aika.{User, Repo, Organisation}

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

end
