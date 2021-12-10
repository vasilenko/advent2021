defmodule Navigation do
  def score_line(input, acc \\ [])

  def score_line([], []), do: {:good, 0}
  def score_line([], acc), do: {:incomplete, calc_incomplete_score(acc, 0)}

  def score_line(["(" | rest], acc), do: score_line(rest, ["(" | acc])
  def score_line(["[" | rest], acc), do: score_line(rest, ["[" | acc])
  def score_line(["{" | rest], acc), do: score_line(rest, ["{" | acc])
  def score_line(["<" | rest], acc), do: score_line(rest, ["<" | acc])

  def score_line([")" | rest], ["(" | acc]), do: score_line(rest, acc)
  def score_line(["]" | rest], ["[" | acc]), do: score_line(rest, acc)
  def score_line(["}" | rest], ["{" | acc]), do: score_line(rest, acc)
  def score_line([">" | rest], ["<" | acc]), do: score_line(rest, acc)

  def score_line([")" | _], _), do: {:corrupted, 3}
  def score_line(["]" | _], _), do: {:corrupted, 57}
  def score_line(["}" | _], _), do: {:corrupted, 1197}
  def score_line([">" | _], _), do: {:corrupted, 25137}

  defp calc_incomplete_score([], total), do: total
  defp calc_incomplete_score(["(" | rest], total), do: calc_incomplete_score(rest, total * 5 + 1)
  defp calc_incomplete_score(["[" | rest], total), do: calc_incomplete_score(rest, total * 5 + 2)
  defp calc_incomplete_score(["{" | rest], total), do: calc_incomplete_score(rest, total * 5 + 3)
  defp calc_incomplete_score(["<" | rest], total), do: calc_incomplete_score(rest, total * 5 + 4)

  def sum_score(scores, type), do: reduce_score_by_type(scores, type, 0, &(&1 + &2))

  def median_score(scores, type) do
    values = reduce_score_by_type(scores, type, [], &[&1 | &2])
    index = ceil(length(values) / 2) - 1

    values
    |> Enum.sort()
    |> Enum.at(index)
  end

  defp reduce_score_by_type(scores, type, initial, fun) do
    Enum.reduce(scores, initial, fn
      {^type, score}, acc -> fun.(score, acc)
      _, acc -> acc
    end)
  end
end

data = [
  "[({(<(())[]>[[{[]{<()<>>",
  "[(()[<>])]({[<{<<[]>>(",
  "{([(<{}[<>[]}>{[]{[(<()>",
  "(((({<>}<{<{<>}{[]{[]{}",
  "[[<[([]))<([[{}[[()]]]",
  "[{[{({}]{}}([{[{{{}}([]",
  "{<[[]]>}<{[{[{[]{()[[[]",
  "[<(<(<(<{}))><([]([]()",
  "<{([([[(<>()){}]>(<<{{",
  "<{([{{}}[<[[[<>{}]]]>[]]"
]

scores = Enum.map(data, &(String.graphemes(&1) |> Navigation.score_line()))
result1 = Navigation.sum_score(scores, :corrupted)
result2 = Navigation.median_score(scores, :incomplete)

IO.puts("Result (part one): #{result1}")
IO.puts("Result (part two): #{result2}")
