defmodule AikaWeb.DashboardController do
  use AikaWeb, :controller

  alias Aika.{Timesheets, Accounts}
  import AikaWeb.DashboardView, only: [beginning_of_week: 1, end_of_week: 1]

  def index(conn, %{ "date" => date }) do
    user = conn.assigns[:user]

    {start_date, end_date} = week(date)

    entries = Timesheets.dashboard_entries_for(user, start_date, end_date)
    render conn, entries: entries, date: start_date
  end
  def index(conn, _), do: index(conn, %{"date" => Timex.today()})

  def overview(conn, %{ "date" => date}) do
    org = conn.assigns[:user].organisation

    users = Accounts.users(org)

    {start_date, end_date} = week(date)

    overview_stats = Timesheets.overview_stats_for(org, start_date, end_date)
    render conn, overview_stats: overview_stats, date: start_date, users: users, organisation: org
  end
  def overview(conn, _), do: overview(conn, %{"date" => Timex.today()})

  defp parse_date(date) when is_binary(date) do
    Timex.parse!(date, "%F", :strftime)
  end
  defp parse_date(date), do: date

  defp week(date) do
    start_date = date
    |> parse_date()
    |> beginning_of_week()

    {start_date, end_of_week(start_date)}
  end

end
