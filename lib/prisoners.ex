defmodule Prisoners do
  @moduledoc """
  Documentation for Prisoners.
  """
  alias  Prisoners.Simulation.{HeadToHead, RoundRobin, Generations}

  # %{left: left, right: right, runs: runs}
  def head_to_head(opts) do
    HeadToHead.simulate(opts)
  end

  # %{runs: runs}
  def round_robin(opts) do
    RoundRobin.simulate(opts)
  end

  # %{generations: generations, initial_count: initial_count}
  def generations(opts) do
    Generations.simulate(opts)
  end

  # %{left: left, right: right, runs: runs}
  def debug(opts) do
    HeadToHead.debug(opts)
  end
end
