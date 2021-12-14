defmodule Polymer do
  def calculate(template, db, steps) do
    template_pairs =
      template
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()

    last = List.last(template)

    {{_, min}, {_, max}} =
      1..steps
      |> Enum.reduce(template_pairs, fn _, prev -> count_step_pairs(prev, db) end)
      |> Enum.reduce(%{}, fn {[f, _], count}, acc -> Map.update(acc, f, count, &(&1 + count)) end)
      |> Map.update(last, 1, &(&1 + 1))
      |> Enum.min_max_by(&elem(&1, 1))

    max - min
  end

  defp count_step_pairs(pairs, db) do
    Enum.reduce(pairs, %{}, fn {[f, l], count}, acc ->
      m = db[[f, l]]

      acc
      |> Map.update([f, m], count, &(&1 + count))
      |> Map.update([m, l], count, &(&1 + count))
    end)
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
