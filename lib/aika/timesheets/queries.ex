defmodule Aika.Timesheets.Queries do
  import Ecto.Query, warn: false

  alias Aika.Timesheets.TimeEntry
  alias Aika.Accounts.User

  def time_entries_between(time_entries, start_date, end_date) do
    from  te in time_entries,
          where: te.date >= ^start_date and te.date <= ^end_date
  end

  def time_entries_for_user(user) do
    from te in Ecto.assoc(user, :time_entries)
  end

  def weekly_sums(time_entries) do
    from te in time_entries,
      select: [
        fragment("EXTRACT(WEEK FROM date) as week"), sum(te.duration)
      ],
      group_by: fragment("week")
  end

  def overview_stats_for(org, start_date, end_date) do
    from te in TimeEntry,
      join: u in User,
      on: te.user_id == u.id,
      where: u.organisation_id == ^org.id and te.date >= ^start_date and te.date <= ^end_date,
      group_by: [te.user_id, te.date],
      select: {te.date, te.user_id, sum(te.duration)}
  end

end
