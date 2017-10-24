defmodule AikaWeb.DashboardView do
  use AikaWeb, :view

  def week_commencing(date) do
    start_date = beginning_of_week(date)

    Timex.Interval.new(
      from: start_date,
      until: end_of_week(start_date)
    ) |> Enum.map(&formatted_date/1)
  end

  def previous_week(date) do
    Timex.shift(date, weeks: -1)
    |> isodate()
  end

  def next_week(date) do
    Timex.shift(date, weeks: 1)
    |> isodate()
  end

  defdelegate beginning_of_week(date), to: Timex

  def end_of_week(date) do
    Timex.shift(date, days: 5)
  end

  def date_entries(date, entries) do
    Enum.filter(entries, &(isodate(&1.date) == date))
  end

  def day_duration(date, entries) do
    date_entries(date, entries)
    |> Enum.map(&(&1.duration))
    |> Enum.sum
    |> formatted_duration
  end

  def formatted_duration(time) do
    time / 60
  end

  def week_title(date) do
    week_no = week_number(date)
    case week_no == week_number(Timex.today) do
      true -> "This week"
      _ -> "Week #{week_no}"
    end
  end

  def isodate(date) do
    Timex.format!(date, "%F", :strftime)
  end

  defp formatted_date(date) do
    {
      isodate(date),
      Timex.format!(date, "%A", :strftime)
    }
  end

  defp week_number(date) do
    Timex.format!(date, "{Wiso}")
  end

end
