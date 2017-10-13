defmodule AikaWeb.TimeEntryController do
  use AikaWeb, :controller

  def create(conn, %{ "date" => date, "entry" => %{ "description" => description, "time" => time }}) do
    user = conn.assigns[:user]
    Aika.Entry.create(user, date, description, time)

    redirect conn, to: dashboard_path(conn, :index)
  end

  def delete(conn, %{ "id" => id }) do
    user = conn.assigns[:user]
    Aika.Entry.remove(user, id)

    redirect conn, to: dashboard_path(conn, :index)
  end
end
