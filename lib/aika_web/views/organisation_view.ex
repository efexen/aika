defmodule AikaWeb.OrganisationView do
  use AikaWeb, :view

  def formatted_target_hours(org) do
    AikaWeb.DashboardView.formatted_duration(org.target_hours)
  end

end
