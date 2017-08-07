defmodule Prisoners.Personas.AlwaysDefect do
  def simulate(_, _) do
    :defect
  end
end
