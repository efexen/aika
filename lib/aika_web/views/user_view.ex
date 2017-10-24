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

  defdelegate this_week(), to: AikaWeb.DashboardView
  defdelegate date_entries(date, entries), to: AikaWeb.DashboardView
  defdelegate formatted_duration(duration), to: AikaWeb.DashboardView

end
