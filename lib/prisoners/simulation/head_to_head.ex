defmodule Prisoners.Simulation.HeadToHead do
  alias Prisoners.{Game, Score}

  def simulate(opts) do
    opts
    |> simulations_for
    |> Stream.map(&Game.score/1)
    |> Enum.reduce(&Score.merge/2)
  end

  def debug(opts) do
    simulations_for opts
  end

  defp simulations_for(%{left: left, right: right, runs: runs}) do
    simulate_fn = fn history ->
      game = %Game{
        left: left.simulate(:left, history),
        right: right.simulate(:right, history)
      }

      {game, [game | history]}
    end

    []
    |> Stream.unfold(simulate_fn)
    |> Enum.take(runs)
  end
end
