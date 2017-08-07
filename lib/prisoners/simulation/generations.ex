defmodule Prisoners.Simulation.Generations do
  alias Prisoners.{Personas, Score}
  alias Prisoners.Simulation.HeadToHead

  def simulate(%{generations: generations, initial_count: initial_count}) do
    target_population_count = length(Personas.Helpers.all_personas) * initial_count

    initial_generation = Personas.Helpers.all_personas
    |> Enum.map(fn persona -> {persona, initial_count} end)
    |> Enum.into(%{})

    Enum.reduce (1..generations), initial_generation, fn _, prev ->
      prev
      |> run_generation
      |> scale_generation(target_population_count)
      |> IO.inspect
    end
  end

  defp run_generation(counts_by_persona) do
    counts_by_persona
    |> Stream.flat_map(&list_of/1)                # [{:a, 1}, {:b, 2}] -> [:a, :b, :b]
    |> Enum.shuffle
    |> Enum.chunk(2)                              # generate matchups in pairs
    |> Stream.map(&Enum.sort/1)                   # ensure all pairs are ordered the same
    |> Stream.map(&List.to_tuple/1)               # convert to tuple for easy of grouping
    |> generate_frequencies                       # [:a, :a, :b] -> %{a: 2, b: 1}
    |> Stream.map(&frequency_to_opts/1)
    |> Stream.flat_map(&simulate_head_to_head/1)
    |> Enum.reduce(%{}, &aggregate_scores/2)
  end

  defp scale_generation(generation, target_population_count) do
    population_count = generation |> Map.values |> Enum.sum

    scale_fn = fn {k, count} ->
      scaled_count = round((count * target_population_count) / population_count)

      {k, scaled_count}
    end

    generation
    |> Enum.map(scale_fn)
    |> Enum.into(%{})
  end

  defp generate_frequencies list do
    Enum.reduce list, %{}, fn el, counts ->
      Map.update counts, el, 1, & &1 + 1
    end
  end

  defp frequency_to_opts({{left, right}, runs}) do
    %{left: left, right: right, runs: runs}
  end

  defp list_of({el, count}) do
    Enum.map (1..count), fn _ -> el end
  end

  defp simulate_head_to_head(opts = %{left: left, right: right, runs: _runs}) do
    %Score{left: left_score, right: right_score} = HeadToHead.simulate(opts)

    [{left, left_score}, {right, right_score}]
  end

  defp aggregate_scores({persona, score}, scores) do
    Map.update scores, persona, score, & &1 + score
  end
end
