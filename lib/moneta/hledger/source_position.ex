defmodule Moneta.Hledger.SourcePosition do
  defstruct column: nil, line: nil, file: nil

  def cast(data) do
    %__MODULE__{
      column: data["sourceColumn"],
      line: data["sourceLine"],
      file: data["sourceName"]
    }
  end
end
