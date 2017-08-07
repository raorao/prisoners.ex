defmodule Prisoners.Personas.BackStabber do
  alias Prisoners.Personas.Helpers
  alias Prisoners.{Game, Move}

  def simulate(_player, []) do
    :cooperate
  end

  def simulate(player, [last_Game | _tail]) do
    player
    |> Helpers.opponent
    |> Game.for(last_Game)
    |> Move.opposite
  end
end
