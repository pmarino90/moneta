defmodule Moneta.HledgerTest do
  @moduledoc false
  use ExUnit.Case
  use Mneme

  alias Moneta.Hledger.ReportRow
  alias Moneta.Hledger.PeriodicReport
  alias Moneta.Hledger
  alias Moneta.Hledger.Transaction

  describe "Querying a journal" do
    test "reads an empty journal" do
      transactions = Hledger.transactions(ledger: "test/support/journals/empty.journal")

      assert transactions == []
    end

    test "returns all transactions in a journal" do
      transactions = Hledger.transactions(ledger: "test/support/journals/test.journal")

      [opening_balance, _, _] = transactions

      assert Enum.count(transactions) == 3

      auto_assert [
                    %Transaction{},
                    %Transaction{
                      date: "2024-05-01",
                      description: "FOOBAR",
                      index: 2,
                      postings: [%Moneta.Hledger.Posting{}, %Moneta.Hledger.Posting{}],
                      source_position: [
                        %Moneta.Hledger.SourcePosition{},
                        %Moneta.Hledger.SourcePosition{}
                      ],
                      status: "Cleared"
                    },
                    %Transaction{
                      date: "2024-05-01",
                      description: "AAA",
                      index: 3,
                      postings: [%Moneta.Hledger.Posting{}, %Moneta.Hledger.Posting{}],
                      source_position: [
                        %Moneta.Hledger.SourcePosition{},
                        %Moneta.Hledger.SourcePosition{}
                      ],
                      status: "Cleared"
                    }
                  ] <- transactions
    end
  end

  describe "Income Statement" do
    test "Basic income statement" do
      auto_assert %Moneta.Hledger.CompoundBalanceReport{
                    sub_reports: [
                      %PeriodicReport{
                        dates: [
                          [
                            %Moneta.Hledger.Date{contents: "2024-05-01", tag: "Exact"},
                            %Moneta.Hledger.Date{contents: "2024-06-01", tag: "Exact"}
                          ]
                        ],
                        name: "Revenues",
                        totals: %{amounts: [[]], average: [], total: []}
                      },
                      %PeriodicReport{
                        rows: [
                          %ReportRow{
                            amounts: [
                              [
                                %Moneta.Hledger.Amount{
                                  quantity: %{
                                    decimal_mantissa: 10540,
                                    decimal_places: 2,
                                    floating_point: 105.4
                                  }
                                }
                              ]
                            ]
                          },
                          %ReportRow{
                            amounts: [
                              [
                                %Moneta.Hledger.Amount{
                                  quantity: %{
                                    decimal_mantissa: 10070,
                                    decimal_places: 2,
                                    floating_point: 100.7
                                  }
                                }
                              ]
                            ]
                          },
                          %ReportRow{
                            amounts: [
                              [
                                %Moneta.Hledger.Amount{
                                  quantity: %{
                                    decimal_mantissa: 470,
                                    decimal_places: 2,
                                    floating_point: 4.7
                                  }
                                }
                              ]
                            ]
                          }
                        ]
                      }
                    ]
                  } <-
                    Hledger.income_statement(
                      ledger: "test/support/journals/test.journal",
                      start_date: "2024/05",
                      end_date: "2024/06"
                    )
    end
  end

  describe "Balance Sheet" do
    test "Basic Balance sheet" do
      auto_assert %Moneta.Hledger.CompoundBalanceReport{
                    sub_reports: [
                      %PeriodicReport{
                        dates: [
                          [
                            %Moneta.Hledger.Date{contents: "2024-05-01", tag: "Exact"},
                            %Moneta.Hledger.Date{contents: "2024-06-01", tag: "Exact"}
                          ]
                        ],
                        name: "Assets",
                        totals: %{
                          amounts: [
                            [
                              %Moneta.Hledger.Amount{
                                quantity: %{
                                  decimal_mantissa: 89460,
                                  decimal_places: 2,
                                  floating_point: 894.6
                                }
                              }
                            ]
                          ],
                          average: [
                            %Moneta.Hledger.Amount{
                              quantity: %{
                                decimal_mantissa: 8946,
                                decimal_places: 1,
                                floating_point: 894.6
                              }
                            }
                          ],
                          total: [
                            %Moneta.Hledger.Amount{
                              quantity: %{
                                decimal_mantissa: 89460,
                                decimal_places: 2,
                                floating_point: 894.6
                              }
                            }
                          ]
                        }
                      },
                      %PeriodicReport{
                        dates: [
                          [
                            %Moneta.Hledger.Date{contents: "2024-05-01", tag: "Exact"},
                            %Moneta.Hledger.Date{contents: "2024-06-01", tag: "Exact"}
                          ]
                        ],
                        name: "Liabilities",
                        totals: %{amounts: [[]], average: [], total: []}
                      }
                    ]
                  } <-
                    Hledger.balance_sheet(
                      ledger: "test/support/journals/test.journal",
                      start_date: "2024/05",
                      end_date: "2024/06"
                    )
    end
  end
end
