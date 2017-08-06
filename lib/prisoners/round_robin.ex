defmodule Prisoners.RoundRobin do
  alias Prisoners.{Game, Personas, Score}

  def run(runs) do
    personas = Personas.Helpers.all_personas

    matchups = for left <- personas, right <- personas, do: {left, right}

    matches = Enum.flat_map matchups, fn {left, right} ->
      {_simulation, score} = Game.simulate(%{left: left, right: right, runs: runs})
      %Score{left: left_score, right: right_score} = score

      [{left, left_score}, {right, right_score}]
    end

    Enum.reduce matches, %{}, fn {persona, score}, scores ->
      Map.update scores, persona, score, & &1 + score
    end
  end

  def generation(initial_count) when is_integer(initial_count) do
    Personas.Helpers.all_personas
    |> Enum.map(fn persona -> {persona, initial_count} end)
    |> Enum.into(%{})
  end

  def generation(counts_by_persona) do
    matches = counts_by_persona
    |> Enum.flat_map(&list_of/1)
    |> Enum.shuffle
    |> Enum.chunk(2)
    |> Stream.map(&Enum.sort/1)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.group_by(& &1)
    |> Enum.flat_map(fn {{left, right}, val} ->
      opts = %{left: left, right: right, runs: length(val)}
      {_simulation, score} = Game.simulate(opts)
      %Score{left: left_score, right: right_score} = score
      [{left, left_score}, {right, right_score}]
    end)

    Enum.reduce matches, %{}, fn {persona, score}, scores ->
      Map.update scores, persona, score, & &1 + score
    end
  end

  def evolve(generations, initial_count) do
    target_population_count = length(Personas.Helpers.all_personas) * initial_count
    Enum.reduce (1..generations), generation(initial_count), fn _, prev ->
      next = generation prev

      population_count = next |> Map.values |> Enum.sum

      scaled_next = Enum.map(next, fn {k, count} ->
        scaled_count = round((count * target_population_count) / population_count)

        {k, scaled_count}
      end) |> Enum.into(%{})

      IO.inspect scaled_next

      scaled_next
    end
  end

  defp list_of({el, count}) do
    Enum.map (1..count), fn _ -> el end
  end
end


