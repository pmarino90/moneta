defmodule MonetaWeb.TransactionsLive do
  use MonetaWeb, :live_view

  alias Moneta.Hledger
  alias Moneta.Session
  alias Moneta.Hledger.Amount

  def render(assigns) do
    ~H"""
    transactions
    <section class="flex flex-col space-y-2">
      <article
        :for={transaction <- @transactions}
        class={[
          "text-sm hover:bg-slate-200",
          transaction.status == "Pending" && "text-yellow-700",
          transaction.status == "Unmarked" && "text-slate-600"
        ]}
      >
        <section class="flex space-x-2">
          <span><%= transaction.date %></span>
          <span><%= transaction.description %></span>
        </section>
        <section class="flex flex-col">
          <article :for={posting <- transaction.postings} class="flex pl-5">
            <div class="w-2/3"><%= posting.account %></div>
            <div class="w-1/3">
              <%= for a <- posting.amount do %>
                <.amount amount={a} />
              <% end %>
            </div>
          </article>
        </section>
      </article>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    transactions = fetch_transactions()

    socket =
      socket
      |> assign(transactions: transactions)

    {:ok, socket}
  end

  defp amount(assigns) do
    ~H"""
    <span class={[
      @amount.quantity.floating_point < 0 && "text-red-500"
    ]}>
      <%= render_amount(@amount) %>
    </span>
    """
  end

  def render_amount(%Amount{} = amount) do
    Moneta.Cldr.Number.to_string!(amount.quantity.floating_point, currency: "EUR")
  end

  defp fetch_transactions() do
    Hledger.transactions(ledger: Session.get_current_ledger())
  end
end
