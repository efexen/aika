defmodule AikaWeb.ExportController do
  use AikaWeb, :controller

  alias Aika.{Timesheets, Exports.CSVExporter}

  def new(conn, _params) do
    render conn
  end

  def export(conn, %{"export" => %{"month" => month, "year" => year}}) do
    org = conn.assigns[:user].organisation

    csv = Timesheets.export_for(org, {String.to_integer(month), String.to_integer(year)})
    |> CSVExporter.org_entries_to_csv()

    send_download(conn, {:binary, csv}, filename: "aika_export_#{month}#{year}.csv")
  end

end
