defmodule Aoc.Solutions.Day10 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    asteroid_set =
      input
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> setify(0)

    location =
      count_asteroids(asteroid_set, MapSet.to_list(asteroid_set), %{})
      |> Map.to_list()
      |> Enum.max_by(fn {_, count} -> count end)
      |> elem(0)

    asteroid_set
    |> MapSet.delete(location)
    |> vaporize(location)
    |> Enum.at(199)
    |> output()
  end

  defp output({x, y}), do: x * 100 + y

  defp vaporize(asteroid_set, {cx, cy}) do
    asteroid_set
    |> Enum.map(fn {x, y} -> {{x, y}, angle(cx - x, cy - y), dist(cx - x, cy - y)} end)
    |> Enum.group_by(fn {_, angle, _} -> angle end)
    |> Map.values()
    |> Enum.map(&Enum.sort_by(&1, fn {_, _, dist} -> dist end))
    |> Enum.map(&Enum.with_index/1)
    |> Enum.map(
      &Enum.map(&1, fn {{pos, ang, _}, index} -> {pos, ang + index * :math.pi() * 2} end)
    )
    |> Enum.concat()
    |> Enum.sort_by(fn {_, ang} -> ang end)
    |> Enum.map(&elem(&1, 0))
  end

  defp angle(x, y), do: angle(-:math.atan2(x, y))
  defp angle(a) when a < 0, do: a + 2 * :math.pi()
  defp angle(a), do: a
  defp dist(x, y), do: :math.pow(x, 2) + :math.pow(y, 2)

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
