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

  def nav_template(%{assigns: %{ user: _ }}) do
    "login_nav.html"
  end
  def nav_template(_), do: "logout_nav.html"

end
