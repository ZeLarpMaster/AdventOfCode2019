defmodule Aoc.Input do
  @doc """
  Fetches the raw content of the day's input
  """
  def get_raw(day) do
    File.read!("inputs/day#{day}.txt") |> String.trim()
  end
end
