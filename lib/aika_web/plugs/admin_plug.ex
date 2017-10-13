defmodule AikaWeb.AdminPlug do
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _default) do
    case conn.assigns[:user].role == 1 do
      true -> conn
      false ->
        conn
        |> put_flash(:error, "You must be admin for that")
        |> redirect(to: "/")
        |> halt()
    end
  end

end
