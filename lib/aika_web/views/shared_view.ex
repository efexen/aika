defmodule AikaWeb.SharedView do
  use AikaWeb, :view

  def username(conn) do
    conn.assigns[:user].email
    |> String.split("@")
    |> hd()
  end

  def admin?(conn) do
    conn.assigns[:user].role == 1
  end

end
