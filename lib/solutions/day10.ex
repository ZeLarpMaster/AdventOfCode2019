defmodule Aoc.Solutions.Day10 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    asteroid_set =
      input
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> setify(0)

    count_asteroids(asteroid_set, MapSet.to_list(asteroid_set), %{})
    |> IO.inspect(label: "Count")
    |> Map.to_list()
    |> Enum.max_by(fn {_, count} -> count end)
    |> elem(1)
  end

  defp count_asteroids(_, [], counter), do: counter

  defp count_asteroids(set, [pos1 | tail], counter) do
    count =
      Enum.count(set, fn pos2 ->
        IO.inspect(not Enum.any?(set, &in_between?(pos1, &1, pos2)),
          label: "Can #{inspect(pos1)} see #{inspect(pos2)}"
        )
      end)

    count_asteroids(set, tail, Map.put(counter, pos1, count))
  end

  defp in_between?(p1, middle, p2) when p1 == middle or p2 == middle or p1 == p2, do: false

  defp in_between?({x1, y1}, {x2, y2}, {x3, y3}) do
    dx = x3 - x1
    dy = y3 - y1
    gcd = Integer.gcd(abs(dx), abs(dy))
    dx = div(dx, gcd)
    dy = div(dy, gcd)
    dx2 = x2 - x1
    dy2 = y2 - y1

    div(dx2, dx) == div(dy2, dy) and rem(dx2, dx) == 0 and rem(dy2, dy) == 0
  end

  defp setify([], _), do: MapSet.new()

  defp setify([head | tail], index),
    do: setify(head, index, 0) |> MapSet.union(setify(tail, index + 1))

  defp setify([], _, _), do: MapSet.new()
  defp setify(["#" | tail], y, x), do: setify(tail, y, x + 1) |> MapSet.put({x, y})
  defp setify(["." | tail], y, x), do: setify(tail, y, x + 1)
end
