defmodule Seven do
  def decode(line) do
    [input, output] = String.split(line, " | ")
    %{2 => [d1], 4 => [d4]} = Enum.group_by(parse(input), &MapSet.size/1)

    output
    |> parse()
    |> Enum.reduce("", fn dx, acc ->
      d4_intersections = MapSet.intersection(dx, d4)
      d1_intersections = MapSet.intersection(dx, d1)

      digit =
        case {MapSet.size(dx), MapSet.size(d4_intersections), MapSet.size(d1_intersections)} do
          {2, _, _} -> "1"
          {3, _, _} -> "7"
          {4, _, _} -> "4"
          {7, _, _} -> "8"
          {5, 2, _} -> "2"
          {5, 3, 1} -> "5"
          {5, 3, 2} -> "3"
          {6, 4, _} -> "9"
          {6, 3, 1} -> "6"
          {6, 3, 2} -> "0"
        end

      acc <> digit
    end)
    |> String.to_integer()
  end

  defp parse(str) do
    str
    |> String.split(" ", trim: true)
    |> Enum.map(&(String.graphemes(&1) |> MapSet.new()))
  end
end

data = [
  "be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe",
  "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc",
  "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg",
  "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb",
  "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea",
  "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb",
  "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe",
  "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef",
  "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb",
  "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"
]

frequencies =
  data
  |> Enum.flat_map(fn line ->
    [_, output] = String.split(line, " | ")

    output
    |> String.split(" ")
    |> Enum.map(&String.length/1)
  end)
  |> Enum.frequencies()

result1 = frequencies[2] + frequencies[3] + frequencies[4] + frequencies[7]

result2 =
  data
  |> Enum.map(&Seven.decode/1)
  |> Enum.sum()

IO.puts("Result (part one): #{result1}")
IO.puts("Result (part two): #{result2}")
