defmodule Moneta.Hledger.Amount do
  defstruct commodity: nil,
            cost: nil,
            quantity: %{
              decimal_mantissa: nil,
              decimal_places: nil,
              floating_point: nil
            },
            style: %{
              commodity_side: nil,
              commodity_spaced: false,
              decimal_mark: nil,
              digit_groups: [],
              precision: nil,
              rounding: nil
            }

  def cast(data) do
    %__MODULE__{
      commodity: data["acommodity"],
      cost: data["acost"],
      quantity: %{
        decimal_mantissa: data["aquantity"]["decimalMantissa"],
        decimal_places: data["aquantity"]["decimalPlaces"],
        floating_point: data["aquantity"]["floatingPoint"]
      },
      style: %{
        commodity_side: data["astyle"]["ascommodityside"],
        commodity_spaced: data["astyle"]["ascommodityspaced"],
        decimal_mark: data["astyle"]["asdecimalmark"],
        digit_groups: data["astyle"]["asdigitgroups"],
        precision: data["astyle"]["asprecision"],
        rounding: data["astyle"]["asrounding"]
      }
    }
  end

  def cast_deep(data) do
    data
    |> Enum.map(fn amounts -> Enum.map(amounts, &cast/1) end)
  end
end
