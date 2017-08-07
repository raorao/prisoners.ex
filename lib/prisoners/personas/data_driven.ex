defmodule Prisoners.Personas.DataDriven do
  alias Prisoners.{Game}
  alias Prisoners.Personas.Helpers

  def simulate(_player, history) when length(history) <= 1 do
    :cooperate
  end

  def simulate(player, history) do
    history
    |> Enum.take(3)
    |> Enum.map(fn entry -> player |> Helpers.opponent |> Game.for(entry) end)
    |> Enum.group_by(& &1)
    |> Enum.max_by(& elem(&1, 1) |> length)
    |> elem(0)
  end
end
