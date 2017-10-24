defmodule AikaWeb.TimeEntryController do
  use AikaWeb, :controller
  alias Aika.Timesheets
  import AikaWeb.DashboardView, only: [isodate: 1]

  def create(conn, %{ "date" => date, "entry" => %{ "description" => description, "time" => time }}) do
    user = conn.assigns[:user]
    Timesheets.create(user, date, description, time)

    redirect conn, to: dashboard_path(conn, :index, date: date)
  end

  def delete(conn, %{ "id" => id }) do
    user = conn.assigns[:user]
    case Timesheets.remove(user, id) do
      nil ->
        redirect conn, to: dashboard_path(conn, :index)
      {:ok, entry} ->
        redirect conn, to: dashboard_path(conn, :index, date: isodate(entry.date))
    end
  end

end
