defmodule AikaWeb.ApiAuthPlug do
  import Plug.Conn
  alias Aika.{Repo, Accounts.User}

  def init(default), do: default

  def call(conn, _) do
    with user_id        <- conn.params["user_id"],
         api_token      <- conn.params["api_token"],
         user           <- Repo.get(User, user_id),
         user_api_token <- user && user.api_token,
         true           <- api_token == user_api_token do
      assign(conn, :user, user)
    else
      _ ->
        conn
        |> send_resp(401, "unauthorized")
        |> halt()
    end
  end
end
