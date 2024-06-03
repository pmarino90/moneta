defmodule Moneta.HledgerTest do
  @moduledoc false
  use ExUnit.Case

  alias Moneta.Hledger
  alias Moneta.Hledger.{Transaction, Posting, Amount}

  describe "Querying a journal" do
    test "reads an empty journal" do
      postings = Hledger.transactions(ledger: "test/support/journals/empty.journal")

      assert postings == []
    end

    test "returns all transactions in a journal" do
      transactions = Hledger.transactions(ledger: "test/support/journals/test.journal")

      [opening_balance, _, _] = transactions

      assert Enum.count(transactions) == 3

      assert opening_balance == %Transaction{
               code: "",
               comment: "",
               date: "2024-05-01",
               description: "opening balances",
               index: 1,
               status: "Cleared",
               postings: [
                 %Posting{
                   account: "assets:ABC:current",
                   amount: [
                     %Amount{
                       commodity: "€",
                       cost: nil,
                       quantity: %{
                         decimal_mantissa: 100_000,
                         decimal_places: 2,
                         floating_point: 1000
                       },
                       style: %{
                         commodity_side: "L",
                         commodity_spaced: false,
                         decimal_mark: ",",
                         digit_groups: [".", [3]],
                         precision: 2,
                         rounding: "NoRounding"
                       }
                     }
                   ],
                   balance_assertion: nil,
                   comment: "",
                   date: nil,
                   original: nil,
                   status: "Unmarked",
                   tags: [],
                   transaction_index: "1",
                   type: "RegularPosting"
                 },
                 %Posting{
                   account: "equity:opening balances",
                   amount: [
                     %Amount{
                       commodity: "€",
                       cost: nil,
                       quantity: %{
                         decimal_mantissa: -100_000,
                         decimal_places: 2,
                         floating_point: -1000
                       },
                       style: %{
                         commodity_side: "L",
                         commodity_spaced: false,
                         decimal_mark: ",",
                         digit_groups: [".", [3]],
                         precision: 2,
                         rounding: "NoRounding"
                       }
                     }
                   ],
                   balance_assertion: nil,
                   comment: "",
                   date: nil,
                   original: nil,
                   status: "Unmarked",
                   tags: [],
                   transaction_index: "1",
                   type: "RegularPosting"
                 }
               ],
               source: nil
             }
    end
  end

  describe "Income Statement" do
    test "Basic income statement" do
      statement =
        Hledger.income_statement(
          ledger: "test/support/journals/test.journal",
          start_date: "2024/05",
          end_date: "2024/06"
        )

      assert statement == %Moneta.Hledger.CompoundBalanceReport{
               dates: [
                 [
                   %Moneta.Hledger.Date{
                     contents: "2024-05-01",
                     tag: "Exact"
                   },
                   %Moneta.Hledger.Date{
                     contents: "2024-06-01",
                     tag: "Exact"
                   }
                 ]
               ],
               sub_reports: [
                 %Moneta.Hledger.PeriodicReport{
                   dates: [
                     [
                       %Moneta.Hledger.Date{
                         contents: "2024-05-01",
                         tag: "Exact"
                       },
                       %Moneta.Hledger.Date{
                         contents: "2024-06-01",
                         tag: "Exact"
                       }
                     ]
                   ],
                   name: "Revenues",
                   rows: [],
                   totals: %{amounts: [[]], average: [], total: []}
                 },
                 %Moneta.Hledger.PeriodicReport{
                   dates: [
                     [
                       %Moneta.Hledger.Date{
                         contents: "2024-05-01",
                         tag: "Exact"
                       },
                       %Moneta.Hledger.Date{
                         contents: "2024-06-01",
                         tag: "Exact"
                       }
                     ]
                   ],
                   name: "Expenses",
                   rows: [
                     %Moneta.Hledger.ReportRow{
                       amounts: [
                         [
                           %Moneta.Hledger.Amount{
                             commodity: "€",
                             cost: nil,
                             quantity: %{
                               decimal_mantissa: 10070,
                               decimal_places: 2,
                               floating_point: 100.7
                             },
                             style: %{
                               commodity_side: "L",
                               commodity_spaced: false,
                               decimal_mark: ",",
                               digit_groups: [".", [3]],
                               precision: 1,
                               rounding: "HardRounding"
                             }
                           }
                         ]
                       ],
                       average: [
                         %Moneta.Hledger.Amount{
                           commodity: "€",
                           cost: nil,
                           quantity: %{
                             decimal_mantissa: 1007,
                             decimal_places: 1,
                             floating_point: 100.7
                           },
                           style: %{
                             commodity_side: "L",
                             commodity_spaced: false,
                             decimal_mark: ",",
                             digit_groups: [".", [3]],
                             precision: 1,
                             rounding: "HardRounding"
                           }
                         }
                       ],
                       name: "expenses:Electricity",
                       total: [
                         %Moneta.Hledger.Amount{
                           commodity: "€",
                           cost: nil,
                           quantity: %{
                             decimal_mantissa: 10070,
                             decimal_places: 2,
                             floating_point: 100.7
                           },
                           style: %{
                             commodity_side: "L",
                             commodity_spaced: false,
                             decimal_mark: ",",
                             digit_groups: [".", [3]],
                             precision: 1,
                             rounding: "HardRounding"
                           }
                         }
                       ]
                     },
                     %Moneta.Hledger.ReportRow{
                       amounts: [
                         [
                           %Moneta.Hledger.Amount{
                             commodity: "€",
                             cost: nil,
                             quantity: %{
                               decimal_mantissa: 470,
                               decimal_places: 2,
                               floating_point: 4.7
                             },
                             style: %{
                               precision: 1,
                               rounding: "HardRounding",
                               commodity_side: "L",
                               commodity_spaced: false,
                               decimal_mark: ",",
                               digit_groups: [".", [3]]
                             }
                           }
                         ]
                       ],
                       average: [
                         %Moneta.Hledger.Amount{
                           commodity: "€",
                           cost: nil,
                           quantity: %{
                             decimal_mantissa: 47,
                             decimal_places: 1,
                             floating_point: 4.7
                           },
                           style: %{
                             precision: 1,
                             rounding: "HardRounding",
                             commodity_side: "L",
                             commodity_spaced: false,
                             decimal_mark: ",",
                             digit_groups: [".", [3]]
                           }
                         }
                       ],
                       name: "expenses:Groceries",
                       total: [
                         %Moneta.Hledger.Amount{
                           commodity: "€",
                           cost: nil,
                           quantity: %{
                             decimal_mantissa: 470,
                             decimal_places: 2,
                             floating_point: 4.7
                           },
                           style: %{
                             precision: 1,
                             rounding: "HardRounding",
                             commodity_side: "L",
                             commodity_spaced: false,
                             decimal_mark: ",",
                             digit_groups: [".", [3]]
                           }
                         }
                       ]
                     }
                   ],
                   totals: %{
                     amounts: [
                       [
                         %Moneta.Hledger.Amount{
                           commodity: "€",
                           cost: nil,
                           quantity: %{
                             decimal_mantissa: 10540,
                             decimal_places: 2,
                             floating_point: 105.4
                           },
                           style: %{
                             commodity_side: "L",
                             commodity_spaced: false,
                             decimal_mark: ",",
                             digit_groups: [".", [3]],
                             precision: 1,
                             rounding: "HardRounding"
                           }
                         }
                       ]
                     ],
                     average: [
                       %Moneta.Hledger.Amount{
                         commodity: "€",
                         cost: nil,
                         quantity: %{
                           decimal_mantissa: 1054,
                           decimal_places: 1,
                           floating_point: 105.4
                         },
                         style: %{
                           commodity_side: "L",
                           commodity_spaced: false,
                           decimal_mark: ",",
                           digit_groups: [".", [3]],
                           precision: 1,
                           rounding: "HardRounding"
                         }
                       }
                     ],
                     total: [
                       %Moneta.Hledger.Amount{
                         commodity: "€",
                         cost: nil,
                         quantity: %{
                           decimal_mantissa: 10540,
                           decimal_places: 2,
                           floating_point: 105.4
                         },
                         style: %{
                           commodity_side: "L",
                           commodity_spaced: false,
                           decimal_mark: ",",
                           digit_groups: [".", [3]],
                           precision: 1,
                           rounding: "HardRounding"
                         }
                       }
                     ]
                   }
                 }
               ],
               title: "Income Statement 2024-05",
               totals: %{
                 amounts: [
                   [
                     %Moneta.Hledger.Amount{
                       commodity: "€",
                       cost: nil,
                       quantity: %{
                         decimal_mantissa: -10540,
                         decimal_places: 2,
                         floating_point: -105.4
                       },
                       style: %{
                         commodity_side: "L",
                         commodity_spaced: false,
                         decimal_mark: ",",
                         digit_groups: [".", [3]],
                         precision: 1,
                         rounding: "HardRounding"
                       }
                     }
                   ]
                 ],
                 average: [
                   %Moneta.Hledger.Amount{
                     commodity: "€",
                     cost: nil,
                     quantity: %{
                       decimal_mantissa: -1054,
                       decimal_places: 1,
                       floating_point: -105.4
                     },
                     style: %{
                       commodity_side: "L",
                       commodity_spaced: false,
                       decimal_mark: ",",
                       digit_groups: [".", [3]],
                       precision: 1,
                       rounding: "HardRounding"
                     }
                   }
                 ],
                 total: [
                   %Moneta.Hledger.Amount{
                     commodity: "€",
                     cost: nil,
                     quantity: %{
                       decimal_mantissa: -10540,
                       decimal_places: 2,
                       floating_point: -105.4
                     },
                     style: %{
                       commodity_side: "L",
                       commodity_spaced: false,
                       decimal_mark: ",",
                       digit_groups: [".", [3]],
                       precision: 1,
                       rounding: "HardRounding"
                     }
                   }
                 ]
               }
             }
    end
  end
end
