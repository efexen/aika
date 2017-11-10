defmodule AikaWeb.TimeEntryView do
  use AikaWeb, :view

  def render("create.json", %{entry: entry}) do
    json = %{
      id: entry.id,
      date: entry.date,
      description: entry.description,
      duration: entry.description
    }

    json |> Poison.encode!
  end
end
