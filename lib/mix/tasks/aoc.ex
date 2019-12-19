defmodule Mix.Tasks.Aoc do
  use Mix.Task

  import Aoc.Input

  @shortdoc "Executes the `day`th challenge"

  @doc false
  def run([day, "--test", data]) do
    run_day(day, data)
  end

  def run([day]) do
    run_day(day, get_raw(day))
  end

  def run([]) do
    IO.puts("Missing required parameter <day>")
  end

  defp run_day(day, input) do
    IO.puts("Executing day #{day}...")
    output = apply(:"Elixir.Aoc.Solutions.Day#{day}", :execute, [input])
    IO.puts("Output for day #{day}\n#{output}")
  end
end
