defmodule Aoc.Solutions.Day8 do
  @behaviour Aoc.Solutions

  @width 25
  @height 6

  @impl true
  def execute(input) do
    input
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(@width * @height)
    |> Enum.map(&mapify/1)
    |> Enum.reduce(&Map.merge/2)
    |> unmapify()
    |> Enum.map(fn
      0 -> " "
      1 -> "X"
    end)
    |> Enum.chunk_every(@width)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
  end

  defp mapify(layer) do
    layer
    |> Enum.with_index(1)
    # Remove transparent pixels so merging magically flattens the image layers
    |> Enum.reject(fn {value, _index} -> value == 2 end)
    |> Enum.map(fn {value, index} -> {index, value} end)
    |> Enum.into(%{})
  end

  defp unmapify(map) do
    map
    |> Map.to_list()
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
  end
end
