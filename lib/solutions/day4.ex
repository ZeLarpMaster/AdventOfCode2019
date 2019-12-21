defmodule Aoc.Solutions.Day4 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    [min, max] =
      input
      |> String.trim()
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)

    min..max
    |> Flow.from_enumerable()
    |> Flow.map(&Integer.to_string/1)
    |> Flow.filter(&check_criteria/1)
    |> Enum.count()
  end

  defp check_criteria(password), do: check_duplicates(password) and check_increasing(password)

  defp check_duplicates(password) do
    password
    |> String.graphemes()
    |> Enum.reduce([], fn
      # Increment count if head char is current char
      val, [{other, count} | rest] when val == other -> [{val, count + 1} | rest]
      # Prepend new value
      val, [] -> [{val, 1}]
      val, acc -> [{val, 1} | acc]
    end)
    |> Enum.any?(fn {_val, count} -> count == 2 end)
  end

  defp check_increasing(<<x, y, rest::binary>>) when x <= y, do: check_increasing(<<y>> <> rest)
  defp check_increasing(<<_x>>), do: true
  defp check_increasing(<<_x, _rest::binary>>), do: false
end
