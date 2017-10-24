defmodule AikaWeb.UserView do
  use AikaWeb, :view

  def role_name(role) do
    case role do
      1 -> "Admin"
      0 -> "User"
    end
  end

  def username(user) do
    user.email
    |> String.split("@")
    |> hd()
    |> String.capitalize
  end

  # What's a feature envy?
  defdelegate date_entries(date, entries), to: AikaWeb.DashboardView
  defdelegate formatted_duration(duration), to: AikaWeb.DashboardView
  defdelegate previous_week(date), to: AikaWeb.DashboardView
  defdelegate next_week(date), to: AikaWeb.DashboardView
  defdelegate week_title(date), to: AikaWeb.DashboardView
  defdelegate week_commencing(date), to: AikaWeb.DashboardView
  defdelegate day_duration(date, entries), to: AikaWeb.DashboardView

end
