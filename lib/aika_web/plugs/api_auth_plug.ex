defmodule AikaWeb.ApiAuthPlug do
  import Plug.Conn
  import Phoenix.Controller
  alias Aika.{Repo, Accounts.User}

  def init(default), do: default

  def call(conn, _) do
    %{"api_token" => api_token, "user_id" => user_id} = conn.params

    user = Repo.get(User, user_id)

    case user && user.api_token == api_token do
      true -> assign(conn, :user, user)
      _ ->
        conn
        |> put_status(401)
        |> text("401 Unauthorized")
        |> halt()
    end
  end
end
