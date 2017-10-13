defmodule AikaWeb.InviteController do
  use AikaWeb, :controller

  def show(conn, %{ "id" => id }) do
    user = Aika.User.Queries.for_invite(id)
    render conn, user: user, invite_id: id
  end

  def accept(conn, %{ "id" => id, "user" => %{ "password" => password }}) do
    user = Aika.User.Queries.for_invite(id)
    case Aika.Registration.set_password(user, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> redirect(to: dashboard_path(conn, :index))
      {:error, user} ->
        render conn, user: user, invite_id: id
    end
  end

end
