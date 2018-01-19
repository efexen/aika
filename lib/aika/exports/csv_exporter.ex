defmodule Aika.Exports.CSVExporter do

  def org_entries_to_csv(entries) do
    entries
    |> Enum.map(&entry_to_row/1)
    |> prepend_headers()
    |> CSV.encode()
    |> Enum.join("")
  end

  defp entry_to_row(%{
    date: date,
    description: description,
    duration: duration,
    user: %{
      email: email
    }
  }) do
    [
      String.split(email, "@") |> List.first(),
      Timex.format!(date, "{0D}/{0M}/{YYYY}"),
      description,
      inspect(duration / 60)
    ]
  end

  defp prepend_headers(entries) do
    [["name", "date", "description", "duration"] | entries]
  end
end
