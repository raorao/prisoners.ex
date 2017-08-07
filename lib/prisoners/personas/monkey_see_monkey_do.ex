defmodule Prisoners.Personas.MonkeySeeMonkeyDo do
  alias Prisoners.Personas.Helpers
  alias Prisoners.Game

  def simulate(_player, []) do
    :cooperate
  end

  def simulate(player, [last_result | _tail]) do
    player
    |> Helpers.opponent
    |> Game.for(last_result)
  end
end
