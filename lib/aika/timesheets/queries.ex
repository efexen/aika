defmodule Aika.Timesheets.Queries do
  import Ecto.Query, warn: false

  def time_entries_between(time_entries, start_date, end_date) do
    from  te in time_entries,
          where: te.date >= ^start_date and te.date <= ^end_date
  end

  def time_entries_for_user(user) do
    from te in Ecto.assoc(user, :time_entries)
  end
end
