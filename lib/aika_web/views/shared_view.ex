defmodule AikaWeb.SharedView do
  use AikaWeb, :view

  def username(conn) do
    AikaWeb.UserView.username(conn.assigns[:user])
  end

  def admin?(conn) do
    conn.assigns[:user].role == 1
  end

  def nav_template(%{assigns: %{ user: _ }}) do
    "login_nav.html"
  end
  def nav_template(_), do: "logout_nav.html"

  def api_token_button(conn, text) do
    content_tag :p,
      button(text,
        to: user_path(conn, :generate_api_token),
        class: "btn btn-sm btn-outline-success")
  end
end
