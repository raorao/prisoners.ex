defmodule Prisoners.Personas.AlwaysCooperate do
  def simulate(_, _) do
    :cooperate
  end
end
