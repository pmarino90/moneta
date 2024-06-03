defmodule Moneta.Hledger do
  alias Moneta.Hledger.{Transaction, CompoundBalanceReport}

  def transactions(params) do
    Keyword.validate!(params, [:ledger])

    hledger(
      command: "print",
      args: [
        "-f",
        params[:ledger]
      ]
    )
    |> Enum.map(&Transaction.cast/1)
  end

  def income_statement(params) do
    params = Keyword.validate!(params, [:ledger, :start_date, :end_date, forecast: false])

    args =
      [
        "-f",
        params[:ledger],
        "-M",
        "-b",
        params[:start_date],
        "-e",
        params[:end_date],
        "--tree"
      ]
      |> append_if(params[:forecast] == true, "--forecast")

    hledger(
      command: "is",
      args: args
    )
    |> parse_income_statement()
  end

  def balance_sheet(params) do
    params = Keyword.validate!(params, [:ledger, :start_date, :end_date, forecast: false])

    args =
      [
        "-f",
        params[:ledger],
        "-M",
        "-b",
        params[:start_date],
        "-e",
        params[:end_date]
      ]
      |> append_if(params[:forecast] == true, "--forecast")

    hledger(
      command: "bs",
      args: args
    )
    |> parse_balance_sheet()
  end

  defp parse_income_statement(response) do
    CompoundBalanceReport.cast(response)
  end

  defp parse_balance_sheet(response) do
    CompoundBalanceReport.cast(response)
  end

  defp hledger(params) do
    Keyword.validate!(params, [:command, :args])

    {out, 0} =
      System.cmd(
        "hledger",
        [
          params[:command],
          "-c",
          "€1.000,0",
          "-O",
          "json"
        ] ++ params[:args]
      )

    Jason.decode!(out)
  end

  defp append_if(list, condition, item) do
    if condition, do: list ++ [item], else: list
  end
end
