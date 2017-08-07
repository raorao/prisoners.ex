defmodule Prisoners.Simulation.RoundRobin do
  alias Prisoners.{Score, Personas}
  alias Prisoners.Simulation.HeadToHead

  def simulate(%{runs: runs}) do
    personas = Personas.Helpers.all_personas

    matchups = for left <- personas, right <- personas do
      %{left: left, right: right, runs: runs}
    end

    matchups
    |> Enum.flat_map(&simulate_head_to_head/1)
    |> Enum.reduce(%{}, &aggregate_scores/2)
  end

  defp simulate_head_to_head(opts = %{left: left, right: right}) do
    %Score{left: left_score, right: right_score} = HeadToHead.simulate(opts)

    [{left, left_score}, {right, right_score}]
  end

  defp aggregate_scores({persona, score}, scores) do
    Map.update scores, persona, score, & &1 + score
  end
end
