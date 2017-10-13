defmodule AikaWeb.DashboardView do
  use AikaWeb, :view

  def this_week() do
    Timex.Interval.new(
      from: beginning_of_week,
      until: end_of_week
    ) |> Enum.map(&formatted_date/1)
  end

  def beginning_of_week do
    Timex.today()
    |> Timex.beginning_of_week()
  end

  def end_of_week do
    beginning_of_week()
    |> Timex.shift(days: 5)
  end

  def date_entries(date, entries) do
    Enum.filter(entries, &(isodate(&1.date) == date))
  end

  def formatted_duration(time) do
    time / 60
  end

  defp formatted_date(date) do
    {
      isodate(date),
      Timex.format!(date, "%A", :strftime)
    }
  end

  defp isodate(date) do
    Timex.format!(date, "%F", :strftime)
  end

end
