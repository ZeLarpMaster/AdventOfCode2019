defmodule Aoc.Solutions.Day5 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    input
    |> IntcodeMachine.new()
    |> IntcodeMachine.run()
  end
end
