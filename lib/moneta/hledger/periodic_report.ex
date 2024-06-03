defmodule Moneta.Hledger.PeriodicReport do
  alias Moneta.Hledger.{ReportRow, Date, Amount}

  defstruct name: nil,
            dates: [],
            rows: [],
            totals: %{
              amounts: [],
              average: [],
              total: []
            }

  def cast([name, data, _]) do
    %__MODULE__{
      name: name,
      dates: Date.cast_deep(data["prDates"]),
      rows: Enum.map(data["prRows"], &ReportRow.cast/1),
      totals: %{
        amounts: Amount.cast_deep(data["prTotals"]["prrAmounts"]),
        average: data["prTotals"]["prrAverage"] |> Enum.map(&Amount.cast/1),
        total: data["prTotals"]["prrTotal"] |> Enum.map(&Amount.cast/1)
      }
    }
  end
end
