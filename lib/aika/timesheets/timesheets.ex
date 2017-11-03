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

  def overview_stats_for(org, start_date, end_date) do
    org
    |> Queries.overview_stats_for(start_date, end_date)
    |> Repo.all()
  end

  def remove(user, id) do
    entry = Repo.get(TimeEntry, id)

    if entry.user_id == user.id do
      Repo.delete(entry)
    end
  end

  defp parse_date(date) do
    date
    |> Timex.parse!("%F", :strftime)
    |> Timex.to_date()
  end

end
