defmodule Aoc.Solutions do
  @doc "Defines the function executed when running the day's solution"
  @callback execute(input :: binary()) :: any()
end
