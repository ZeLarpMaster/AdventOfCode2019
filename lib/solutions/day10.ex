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
    |> Map.to_list()
    |> Enum.max_by(fn {_, count} -> count end)
    |> elem(1)
  end

  defp count_asteroids(_, [], counter), do: counter

  defp count_asteroids(set, [pos1 | tail], counter) do
    count = Enum.count(set, fn pos2 -> not Enum.any?(set, &in_between?(pos1, &1, pos2)) end)
    count_asteroids(set, tail, Map.put(counter, pos1, count - 1))
  end

  defp in_between?(p1, middle, p2) when p1 == middle or p2 == middle or p1 == p2, do: false

  defp in_between?({x1, y1}, {x2, y2}, {x3, y3}) do
    {dx, dy} = normalize_vector(x3 - x1, y3 - y1)
    {dx2, dy2} = normalize_vector(x2 - x1, y2 - y1)

    dx == dx2 and dy == dy2 and abs(x2 - x1) <= abs(x3 - x1) and abs(y2 - y1) <= abs(y3 - y1)
  end

  defp normalize_vector(x, y) do
    gcd = Integer.gcd(abs(x), abs(y))
    {div(x, gcd), div(y, gcd)}
  end

  defp setify([], _), do: MapSet.new()

  defp setify([head | tail], index),
    do: setify(head, index, 0) |> MapSet.union(setify(tail, index + 1))

  defp setify([], _, _), do: MapSet.new()
  defp setify(["#" | tail], y, x), do: setify(tail, y, x + 1) |> MapSet.put({x, y})
  defp setify(["." | tail], y, x), do: setify(tail, y, x + 1)
end
