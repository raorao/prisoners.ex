defmodule Prisoners.Result do
  alias Prisoners.Score
  defstruct [:left, :right]

  def score(%__MODULE__{left: :defect, right: :cooperate}) do
    %Score{left: 3, right: 0}
  end

  def score(%__MODULE__{left: :cooperate, right: :defect}) do
    %Score{left: 0, right: 3}
  end

  def score(%__MODULE__{left: :defect, right: :defect}) do
    %Score{left: 1, right: 1}
  end

  def score(%__MODULE__{left: :cooperate, right: :cooperate}) do
    %Score{left: 2, right: 2}
  end

  def for(player, result) when player in [:left, :right] do
    Map.get result, player
  end
end
