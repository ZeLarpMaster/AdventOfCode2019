defmodule Aoc.Solutions.Day6 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    couples =
      input
      |> String.split()
      |> Enum.map(&parse_orbit/1)

    orbits =
      Map.merge(
        Enum.group_by(couples, &elem(&1, 0), &elem(&1, 1)),
        Enum.group_by(couples, &elem(&1, 1), &elem(&1, 0)),
        fn _key, left, right -> left ++ right end
      )

    try do
      find_path(orbits, "YOU", "SAN", MapSet.new())
    catch
      visited -> MapSet.size(visited) - 2
    else
      _ -> nil
    end
  end

  defp find_path(_orbits, position, goal, visited) when position == goal, do: throw(visited)

  defp find_path(orbits, position, goal, visited) do
    for new <- Map.get(orbits, position, []), not MapSet.member?(visited, new) do
      find_path(orbits, new, goal, MapSet.put(visited, position))
    end
  end

  defp parse_orbit(line) do
    [object, orbiter] =
      line
      |> String.trim()
      |> String.split(")")

    {orbiter, object}
  end

  # For part 1
  # defp count_orbits(orbits), do: count_orbits(orbits, Map.keys(orbits))
  # defp count_orbits(_orbits, []), do: 0

  # defp count_orbits(orbits, [obj | rest]),
  #   do: count_orbits(orbits, obj) + count_orbits(orbits, rest)

  # defp count_orbits(_orbits, "COM"), do: 0
  # defp count_orbits(orbits, object), do: 1 + count_orbits(orbits, Map.fetch!(orbits, object))
end
