defmodule Aoc.Solutions.Day1 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&calculate_fuel/1)
    |> Enum.sum()
  end

  defp calculate_fuel(mass) do
    fuel =
      mass
      |> Kernel./(3)
      |> Kernel.floor()
      |> Kernel.-(2)

    calculate_additional_fuel(fuel)
  end

  defp calculate_additional_fuel(fuel) when fuel > 0, do: fuel + calculate_fuel(fuel)
  defp calculate_additional_fuel(fuel) when fuel <= 0, do: 0
end
