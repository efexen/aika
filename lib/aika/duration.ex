defmodule Aika.Duration do

  def hours_to_minutes("." <> time), do: hours_to_minutes("0." <> time)
  def hours_to_minutes(time) when is_binary(time) do
    case String.contains?(time, ".") do
      true -> hours_to_minutes(String.to_float(time))
      false -> hours_to_minutes(String.to_integer(time))
    end
  end
  def hours_to_minutes(number), do: round(number * 60)

end
