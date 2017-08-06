defmodule Prisoners.Game do
  alias Prisoners.{Result, Score}

  def simulate(%{left: left, right: right, runs: runs}) do
    simulate_fn = fn history ->
      result = %Result{
        left: left.simulate(:left, history),
        right: right.simulate(:right, history)
      }

      {result, [result | history]}
    end

    simulations = []
    |> Stream.unfold(simulate_fn)
    |> Enum.take(runs)

    score = simulations
    |> Stream.map(&Result.score/1)
    |> Enum.reduce(&Score.merge/2)

    {simulations, score}
  end
end
