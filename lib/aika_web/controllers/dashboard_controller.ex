defmodule AikaWeb.DashboardController do
  use AikaWeb, :controller

  alias Aika.Entry
  import AikaWeb.DashboardView, only: [beginning_of_week: 0, end_of_week: 0]

  def index(conn, _) do
    user = conn.assigns[:user]
    entries = Entry.dashboard_entries_for(user, beginning_of_week, end_of_week)
    render conn, entries: entries
  end
end
