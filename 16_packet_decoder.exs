defmodule Decoder do
  def parse(hex) do
    bit_length = String.length(hex) * 4

    hex
    |> Integer.parse(16)
    |> elem(0)
    |> Integer.to_string(2)
    |> String.pad_leading(bit_length, "0")
  end

  def decode(<<ver::binary-size(3)>> <> "100" <> message) do
    {literal, tail} = decode_literal(message)

    {{:literal, to_integer(ver), literal}, tail}
  end

  def decode(<<ver::binary-size(3)>> <> <<_::binary-size(3)>> <> "0" <> <<size::binary-size(15)>> <> message) do
    packet_size = to_integer(size)
    <<packets::binary-size(packet_size)>> <> tail = message

    stream =
      packets
      |> Stream.unfold(&decode/1)
      |> Stream.take_while(&(!is_nil(&1)))

    {{:operator, to_integer(ver), Enum.to_list(stream)}, tail}
  end

  def decode(<<ver::binary-size(3)>> <> <<_::binary-size(3)>> <> "1" <> <<length::binary-size(11)>> <> message) do
    packet_length = to_integer(length)

    {result, tail} =
      Enum.reduce(1..packet_length, {[], message}, fn _, {acc, tail} ->
        {result, new_tail} = decode(tail)
        {[result | acc], new_tail}
      end)

    {{:operator, to_integer(ver), result}, tail}
  end

  def decode(_), do: nil

  defp decode_literal(message, acc \\ "")

  defp decode_literal("1" <> <<group::binary-size(4)>> <> tail, acc),
    do: decode_literal(tail, acc <> group)

  defp decode_literal("0" <> <<group::binary-size(4)>> <> tail, acc),
    do: {to_integer(acc <> group), tail}


  def sum_versions({{_, ver, children}, _}), do: sum_versions(children, ver)
  def sum_versions([{:literal, ver, _} | next], sum), do: sum_versions(next, sum + ver)

  def sum_versions([{_, ver, children} | next], sum),
    do: sum_versions(next, sum + ver + sum_versions(children, 0))

  def sum_versions([], sum), do: sum

  defp to_integer(str), do: String.to_integer(str, 2)
end

message = "A0016C880162017C3686B18A3D4780"
decoded_message = message |> Decoder.parse() |> Decoder.decode()
result1 = Decoder.sum_versions(decoded_message)

IO.puts("Result (part one): #{result1}")
