defmodule AikaWeb.ExportView do
  use AikaWeb, :view

  def months() do
    Timex.Translator.get_months("en")
    |> Enum.map(fn ({a,b}) -> {b,a} end)
  end

  def years() do
    Timex.now().year..2016
  end

end
