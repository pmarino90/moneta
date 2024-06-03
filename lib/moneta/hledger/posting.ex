defmodule Moneta.Hledger.Posting do
  alias Moneta.Hledger.Amount

  defstruct account: nil,
            amount: nil,
            tags: [],
            type: nil,
            balance_assertion: nil,
            original: nil,
            status: nil,
            comment: nil,
            transaction_index: nil,
            date: nil

  def cast(data) do
    %__MODULE__{
      account: data["paccount"],
      tags: data["ptags"],
      comment: data["pcomment"],
      date: data["date"],
      status: data["pstatus"],
      type: data["ptype"],
      transaction_index: data["ptransaction_"],
      amount: Enum.map(data["pamount"], &Amount.cast/1)
    }
  end
end
