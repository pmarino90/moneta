defmodule Moneta.Hledger.ReportRow do
  alias Moneta.Hledger.Amount

  defstruct amounts: [], average: [], name: nil, total: []

  def cast(data) do
    %__MODULE__{
      amounts: Amount.cast_deep(data["prrAmounts"]),
      average: data["prrAverage"] |> Enum.map(&Amount.cast/1),
      name: data["prrName"],
      total: data["prrTotal"] |> Enum.map(&Amount.cast/1)
    }
  end
end
