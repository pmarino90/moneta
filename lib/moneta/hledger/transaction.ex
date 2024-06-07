defmodule Moneta.Hledger.Transaction do
  alias Moneta.Hledger.{Posting, SourcePosition}

  defstruct code: "",
            comment: "",
            date: nil,
            description: "",
            index: nil,
            status: nil,
            postings: [],
            source_position: nil

  def cast(data) do
    %__MODULE__{
      code: data["tcode"],
      date: data["tdate"],
      description: data["tdescription"],
      index: data["tindex"],
      status: data["tstatus"],
      postings: data["tpostings"] |> Enum.map(&Posting.cast/1),
      source_position: data["tsourcepos"] |> Enum.map(&SourcePosition.cast/1)
    }
  end
end
