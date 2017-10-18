defmodule AikaWeb.SessionController do
  use AikaWeb, :controller

  alias Aika.Accounts

  def create(conn, %{"login" => %{"email" => email, "password" => password}}) do
    case Accounts.id_for_email_and_password(email, password) do
      {:ok, id} ->
        conn
        |> put_session(:current_user, id)
        |> redirect(to: dashboard_path(conn, :index))
      _ ->
        conn
        |> put_flash(:error, "Incorrect email or password")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user)
    |> redirect(to: "/")
  end
end
