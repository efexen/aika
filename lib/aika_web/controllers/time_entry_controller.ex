defmodule AikaWeb.TimeEntryController do
  use AikaWeb, :controller
  alias Aika.Timesheets

  def create(conn, %{ "date" => date, "entry" => %{ "description" => description, "time" => time }}) do
    user = conn.assigns[:user]
    Timesheets.create(user, date, description, time)

    redirect conn, to: dashboard_path(conn, :index)
  end

  def delete(conn, %{ "id" => id }) do
    user = conn.assigns[:user]
    Timesheets.remove(user, id)

    redirect conn, to: dashboard_path(conn, :index)
  end
end
