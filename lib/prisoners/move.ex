defmodule Prisoners.Move do
  def opposite(:cooperate), do: :defect
  def opposite(:defect), do: :cooperate
end
