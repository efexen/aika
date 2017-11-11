defmodule AikaWeb.ApiAuthPlug do
  import Plug.Conn
  alias Aika.{Repo, Accounts.User}

  def init(default), do: default

  def call(%{params: %{"user_id" => user_id, "api_token" => api_token}} = conn, _) do
    if user = Repo.get_by(User, [id: user_id, api_token: api_token]) do
      assign(conn, :user, user)
    else
      unauthorized(conn)
    end
  end
  def call(conn, _), do: unauthorized(conn)

  defp unauthorized(conn) do
    conn
    |> send_resp(401, "unauthorized")
    |> halt()
  end
end
