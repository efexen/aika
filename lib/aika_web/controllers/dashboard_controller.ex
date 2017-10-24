defmodule AikaWeb.DashboardController do
  use AikaWeb, :controller

  alias Aika.Timesheets
  import AikaWeb.DashboardView, only: [beginning_of_week: 1, end_of_week: 1]

  def index(conn, %{ "date" => date }) do
    user = conn.assigns[:user]

    parsed_date = parse_date(date)
    start_date = beginning_of_week(parsed_date)
    end_date = end_of_week(start_date)

    entries = Timesheets.dashboard_entries_for(user, start_date, end_date)
    render conn, entries: entries, date: start_date
  end
  def index(conn, _), do: index(conn, %{"date" => Timex.today()})

  defp parse_date(date) when is_binary(date) do
    Timex.parse!(date, "%F", :strftime)
  end
  defp parse_date(date), do: date

end
