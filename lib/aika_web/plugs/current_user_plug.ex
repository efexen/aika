defmodule AikaWeb.CurrentUserPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _default) do
    with nil <- conn.assigns[:user],
         id <- get_session(conn, :current_user),
         {:ok, user} <- Aika.User.Queries.user_with_organisation(id) do
           assign(conn, :user, user)
    else
      user = %Aika.User{} -> assign(conn, :user, user)
      _ ->
        conn
        |> put_flash(:error, "You need to login")
        |> redirect(to: "/")
        |> halt()
    end
  end

end
