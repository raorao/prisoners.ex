defmodule Prisoners.Score do
  defstruct [:left, :right]

  def merge(%__MODULE__{left: l1, right: r1}, %__MODULE__{left: l2, right: r2}) do
    %__MODULE__{left: l1 + l2, right: r1 + r2}
  end
end
