defmodule AikaWeb.InviteController do
  use AikaWeb, :controller
  alias Aika.Accounts

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
      {:error, user} ->
        render conn, user: user, invite_id: id
    end
  end

end
