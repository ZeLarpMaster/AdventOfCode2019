defmodule Aoc.Solutions.Day9 do
  @behaviour Aoc.Solutions

  @impl true
  def execute(input) do
    input
    |> IntcodeMachine.new()
    |> IntcodeMachine.run()
  end
end
