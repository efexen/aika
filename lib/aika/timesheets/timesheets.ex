defmodule Aika.Timesheets do
  alias Aika.Repo
  alias Aika.Timesheets.{TimeEntry, Queries}

  def create(user, date, description, time) do
    TimeEntry.changeset(%{
      user: user,
      date: parse_date(date),
      description: description,
      duration: parse_time(time)
    }) |> Repo.insert!
  end

  def dashboard_entries_for(user, start_date, end_date) do
    user
    |> Queries.time_entries_for_user()
    |> Queries.time_entries_between(start_date, end_date)
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

  defp parse_time("." <> time), do: parse_time("0." <> time)
  defp parse_time(time) when is_binary(time) do
    case String.contains?(time, ".") do
      true -> parse_time(String.to_float(time))
      false -> parse_time(String.to_integer(time))
    end
  end

  defp parse_time(number), do: round(number * 60)

end
