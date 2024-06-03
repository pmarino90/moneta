defmodule Moneta.Session do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def set_current_ledger(ledger) do
    Agent.update(__MODULE__, fn state -> Map.put(state, :current_ledger, ledger) end)
  end

  def get_current_ledger() do
    Agent.get(__MODULE__, fn state -> state.current_ledger end)
  end
end
