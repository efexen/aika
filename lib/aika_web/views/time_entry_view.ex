defmodule AikaWeb.TimeEntryView do
  use AikaWeb, :view

  def render("create.json", %{entry: entry}) do
    json = %{
      id: entry.id,
      date: entry.date,
      description: entry.description,
      duration: entry.duration
    }

    json |> Poison.encode!
  end
end
