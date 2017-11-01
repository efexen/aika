defmodule AikaWeb.InviteController do
  use AikaWeb, :controller
  alias Aika.Accounts

  def create(conn, %{"invite" => %{"email" => email}}) do
    org = conn.assigns[:user].organisation
    case Accounts.create_invite(org, email) do
      {:ok, _user} ->
        conn
        |> redirect(to: user_path(conn, :index))
      {:error, changeset } ->
        error_messages = Enum.map(changeset.errors, fn({field,{msg,_}}) -> "#{field} #{msg}" end)
                        |> Enum.join(" ")

        conn
        |> put_flash(:error, "Error inviting: #{ error_messages}")
        |> redirect(to: user_path(conn, :index))
    end
  end

  def show(conn, %{ "id" => id }) do
    case Accounts.user_for_invite(id) do
      nil ->
        conn
        |> put_flash(:error, "Invalid or expired invite 😢")
        |> redirect(to: "/")
      user ->
        render conn, user: user, invite_id: id
    end
  end

  def accept(conn, %{ "id" => id, "user" => %{ "password" => password }}) do
    user = Accounts.user_for_invite(id)
    case Accounts.set_password(user, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> redirect(to: dashboard_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Password must be at least 8 characters")
        |> render "show.html", user: user, invite_id: id
    end
  end

end
