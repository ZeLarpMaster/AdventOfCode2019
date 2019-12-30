defmodule Aoc.Solutions.Day6 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    input
    |> String.split()
    |> Enum.map(&parse_orbit/1)
    |> Enum.into(%{})
    |> count_orbits()
  end

  defp parse_orbit(line) do
    [object, orbiter] =
      line
      |> String.trim()
      |> String.split(")")

    {orbiter, object}
  end

  defp count_orbits(orbits), do: count_orbits(orbits, Map.keys(orbits))
  defp count_orbits(_orbits, []), do: 0

  defp count_orbits(orbits, [obj | rest]),
    do: count_orbits(orbits, obj) + count_orbits(orbits, rest)

  defp count_orbits(_orbits, "COM"), do: 0
  defp count_orbits(orbits, object), do: 1 + count_orbits(orbits, Map.fetch!(orbits, object))
end
