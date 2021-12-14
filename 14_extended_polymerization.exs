defmodule Polymer do
  def calculate(template, db, max_step) do
    last = List.last(template)

    {{_, min}, {_, max}} =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()
      |> walk(db, 0, max_step)
      |> Enum.reduce(%{}, fn {[f, _], count}, acc ->
        Map.update(acc, f, count, &(&1 + count))
      end)
      |> Map.update(last, 1, &(&1 + 1))
      |> Enum.min_max_by(&elem(&1, 1))

    max - min
  end

  defp walk(freqs, _, max_step, max_step), do: freqs

  defp walk(freqs, db, step, max_step) do
    freqs
    |> Enum.reduce(%{}, fn {[f, l], count}, acc ->
      m = db[[f, l]]

      acc
      |> Map.update([f, m], count, &(&1 + count))
      |> Map.update([m, l], count, &(&1 + count))
    end)
    |> walk(db, step + 1, max_step)
  end
end

template = String.graphemes("NNCB")

db = %{
  ["C", "H"] => "B",
  ["H", "H"] => "N",
  ["C", "B"] => "H",
  ["N", "H"] => "C",
  ["H", "B"] => "C",
  ["H", "C"] => "B",
  ["H", "N"] => "C",
  ["N", "N"] => "C",
  ["B", "H"] => "H",
  ["N", "C"] => "B",
  ["N", "B"] => "B",
  ["B", "N"] => "B",
  ["B", "B"] => "N",
  ["B", "C"] => "B",
  ["C", "C"] => "N",
  ["C", "N"] => "C"
}

result1 = Polymer.calculate(template, db, 10)
result2 = Polymer.calculate(template, db, 40)

IO.puts("Result (part one): #{result1}")
IO.puts("Result (part two): #{result2}")
