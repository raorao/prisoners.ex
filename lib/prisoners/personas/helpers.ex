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
