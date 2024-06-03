defmodule Moneta.Hledger.Date do
  defstruct contents: nil, tag: nil

  def cast(data) do
    %__MODULE__{
      contents: data["contents"],
      tag: data["tag"]
    }
  end

  def cast_deep(data) do
    data
    |> Enum.map(fn dates -> Enum.map(dates, &cast/1) end)
  end
end
