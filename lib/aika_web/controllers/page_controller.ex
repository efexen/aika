defmodule AikaWeb.PageController do
  use AikaWeb, :controller

  plug :put_layout, "homepage.html"

  def index(conn, _params) do
    render conn, "index.html"
  end
end
