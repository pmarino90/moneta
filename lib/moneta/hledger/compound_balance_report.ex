defmodule Moneta.Hledger.CompoundBalanceReport do
  alias Moneta.Hledger.{Amount, PeriodicReport, Date}

  defstruct title: nil,
            dates: [],
            sub_reports: [],
            totals: %{
              amounts: [],
              average: [],
              total: []
            }

  def cast(data) do
    %__MODULE__{
      title: data["cbrTitle"],
      dates: Date.cast_deep(data["cbrDates"]),
      sub_reports: Enum.map(data["cbrSubreports"], &PeriodicReport.cast/1),
      totals: %{
        amounts: Amount.cast_deep(data["cbrTotals"]["prrAmounts"]),
        average: data["cbrTotals"]["prrAverage"] |> Enum.map(&Amount.cast/1),
        total: data["cbrTotals"]["prrTotal"] |> Enum.map(&Amount.cast/1)
      }
    }
  end
end
