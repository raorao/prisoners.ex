defmodule Prisoners.Personas.Envious do
  alias Prisoners.{Game, Score}

  def simulate(_player, []) do
    :cooperate
  end

  def simulate(player, history) do
    %Score{left: left, right: right} = history
    |> Stream.map(&Game.score/1)
    |> Enum.reduce(&Score.merge/2)

    {ours, theirs} = case player do
      :left  -> {left, right}
      :right -> {right, left}
    end

    if ours > theirs, do: :cooperate, else: :defect
  end
end
