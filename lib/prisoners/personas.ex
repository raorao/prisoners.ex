defmodule Prisoners.Personas.Helpers do
  alias Prisoners.Personas.{
    AlwaysDefect,
    AlwaysCooperate,
    MonkeySeeMonkeyDo,
    BackStabber,
    DataDriven,
    Envious,
  }

  def all_personas do
    [
      AlwaysDefect,
      AlwaysCooperate,
      MonkeySeeMonkeyDo,
      BackStabber,
      DataDriven,
      Envious,
    ]
  end

  def opponent(:left), do: :right
  def opponent(:right), do: :left

end

defmodule Prisoners.Personas.AlwaysDefect do
  def simulate(_, _) do
    :defect
  end
end

defmodule Prisoners.Personas.AlwaysCooperate do
  def simulate(_, _) do
    :cooperate
  end
end

defmodule Prisoners.Personas.MonkeySeeMonkeyDo do
  alias Prisoners.Personas.Helpers
  alias Prisoners.Result

  def simulate(_player, []) do
    :cooperate
  end

  def simulate(player, [last_result | _tail]) do
    player
    |> Helpers.opponent
    |> Result.for(last_result)
  end
end

defmodule Prisoners.Personas.BackStabber do
  alias Prisoners.Personas.Helpers
  alias Prisoners.{Result, Move}

  def simulate(_player, []) do
    :cooperate
  end

  def simulate(player, [last_result | _tail]) do
    player
    |> Helpers.opponent
    |> Result.for(last_result)
    |> Move.opposite
  end
end

defmodule Prisoners.Personas.Envious do
  alias Prisoners.{Result, Score}

  def simulate(_player, []) do
    :cooperate
  end

  def simulate(player, history) do
    %Score{left: left, right: right} = history
    |> Stream.map(&Result.score/1)
    |> Enum.reduce(&Score.merge/2)

    {ours, theirs} = case player do
      :left  -> {left, right}
      :right -> {right, left}
    end

    if ours > theirs, do: :cooperate, else: :defect
  end
end

defmodule Prisoners.Personas.DataDriven do
  alias Prisoners.{Result}
  alias Prisoners.Personas.Helpers

  def simulate(_player, history) when length(history) <= 1 do
    :cooperate
  end

  def simulate(player, history) do
    history
    |> Enum.take(5)
    |> Enum.map(fn entry -> player |> Helpers.opponent |> Result.for(entry) end)
    |> Enum.group_by(& &1)
    |> Enum.max_by(& elem(&1, 1) |> length)
    |> elem(0)
  end
end
