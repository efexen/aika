defmodule Aika.Timesheets do
  alias Aika.{Repo, Duration}
  alias Aika.Timesheets.{TimeEntry, Queries}

  def create(user, date, description, time) do
    TimeEntry.changeset(%{
      user: user,
      date: parse_date(date),
      description: description,
      duration: Duration.hours_to_minutes(time)
    }) |> Repo.insert!
  end

  def dashboard_entries_for(user, start_date, end_date) do
    user
    |> Queries.time_entries_for_user()
    |> Queries.time_entries_between(start_date, end_date)
    |> Repo.all()
  end

  def weekly_totals_for(user) do
    start_date = Timex.today() |> Timex.beginning_of_year()
    end_date = Timex.today() |> Timex.end_of_year()

    user
    |> Queries.time_entries_for_user()
    |> Queries.time_entries_between(start_date, end_date)
    |> Queries.weekly_sums()
    |> Repo.all()
    |> Enum.reduce(%{}, &format_weekly_total/2)
  end

  def overview_stats_for(org, start_date, end_date) do
    org
    |> Queries.overview_stats_for(start_date, end_date)
    |> Repo.all()
    |> Enum.reduce(%{}, fn({date, user_id, duration}, stats) ->
      Map.update(stats, user_id, %{date => duration}, &(Map.put(&1, date, duration)))
    end)
  end

  def export_for(org, {month, year}) do
    start_date = Timex.beginning_of_month(year, month)
    end_date = Timex.end_of_month(year, month)

    org
    |> Queries.time_entries_for_org(start_date, end_date)
    |> Repo.all()
  end

  def remove(user, id) do
    entry = Repo.get(TimeEntry, id)

    if entry.user_id == user.id do
      Repo.delete(entry)
    end
  end

  defp format_weekly_total([week, total], acc) do
    Map.put(acc, round(week), total)
  end

  defp parse_date(date) do
    date
    |> Timex.parse!("%F", :strftime)
    |> Timex.to_date()
  end

end
