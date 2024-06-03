defmodule MonetaWeb.BalanceSheetLive do
  alias Moneta.Session
  alias Moneta.Hledger.Amount
  use MonetaWeb, :live_view

  alias Moneta.Hledger

  @default_settings %{
    "forecast" => false,
    "start_date" => "2024/05",
    "end_date" => "2024/09"
  }

  def render(assigns) do
    ~H"""
    <h1 class="text-xl mb-2"><%= @balance_report.title %></h1>
    <section>
      <details class="pb-5">
        <summary class="text-sm">Report Settings</summary>
        <.simple_form for={@settings} phx-submit="save_settings">
          <div class="flex space-x-2">
            <.input field={@settings[:start_date]} label="Start Date" />
            <.input field={@settings[:end_date]} label="End Date" />
          </div>

          <.input field={@settings[:forecast]} type="checkbox" label="Compute forecast" />
          <:actions>
            <div>
              <.button level="secondary" type="button" phx-click="reset_settings">Reset</.button>
              <.button>Save</.button>
            </div>
          </:actions>
        </.simple_form>
      </details>
      <table>
        <thead>
          <tr class="bg-slate-100">
            <th class="text-left">
              Account
            </th>
            <th :for={dates <- @balance_report.dates} class="text-sm px-2">
              <%= render_dates(dates) %>
            </th>
          </tr>
        </thead>
        <tbody
          :for={report <- @balance_report.sub_reports}
          class="mt-5 text-sm"
          id={"table_#{report.name}"}
        >
          <tr>
            <th class="pt-5 text-left font-normal text-slate-600"><%= report.name %></th>
          </tr>
          <tr :for={row <- report.rows} class="hover:bg-slate-100">
            <td><%= row.name %></td>
            <td :for={amount <- row.amounts} class="text-right">
              <span :if={Enum.empty?(amount)}>
                <%= Moneta.Cldr.Number.to_string!(0, currency: "EUR") %>
              </span>
              <span :for={a <- amount}>
                <.amount amount={a} />
              </span>
            </td>
          </tr>
          <tr class="border-t-2">
            <th class="text-left pb-5 mt-2">Totals</th>
            <td :for={amount <- report.totals.amounts} class="pb-5 mt-2 text-right">
              <span :if={Enum.empty?(amount)}>
                <%= Moneta.Cldr.Number.to_string!(0, currency: "EUR") %>
              </span>
              <span :for={a <- amount} class="font-bold">
                <.amount amount={a} />
              </span>
            </td>
          </tr>
        </tbody>
        <tbody>
          <tr>
            <th class="text-left pb-5 mt-2">Net total</th>
            <td :for={amount <- @balance_report.totals.amounts} class="font-bold pb-5 mt-2 text-right">
              <span :if={Enum.empty?(amount)}>
                <%= Moneta.Cldr.Number.to_string!(0, currency: "EUR") %>
              </span>
              <%= for a <- amount do %>
                <.amount amount={a} />
              <% end %>
            </td>
          </tr>
        </tbody>
      </table>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    balance_report =
      fetch_report(
        start_date: @default_settings["start_date"],
        end_date: @default_settings["end_date"],
        forecast: @default_settings["forecast"]
      )

    socket =
      socket
      |> assign(balance_report: balance_report)
      |> assign(page_title: balance_report.title)
      |> assign(settings: to_form(@default_settings))

    {:ok, socket}
  end

  def handle_event("save_settings", params, socket) do
    report =
      fetch_report(
        start_date: params["start_date"],
        end_date: params["end_date"],
        forecast: params["forecast"] == "true"
      )

    socket =
      socket
      |> assign(settings: to_form(params))
      |> assign(balance_report: report)

    {:noreply, socket}
  end

  def handle_event("reset_settings", _, socket) do
    report =
      fetch_report(
        start_date: @default_settings["start_date"],
        end_date: @default_settings["end_date"],
        forecast: @default_settings["forecast"]
      )

    socket =
      socket
      |> assign(settings: to_form(@default_settings))
      |> assign(balance_report: report)

    {:noreply, socket}
  end

  defp fetch_report(params) do
    Hledger.balance_sheet(
      ledger: Session.get_current_ledger(),
      start_date: params[:start_date],
      end_date: params[:end_date],
      forecast: params[:forecast]
    )
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

  def render_dates([low_bound, up_bound]) do
    low = Date.from_iso8601!(low_bound.contents)
    up = Date.from_iso8601!(up_bound.contents)

    Cldr.Interval.to_string!(low, up, Moneta.Cldr, format: :short)
  end

  def render_amount(%Amount{} = amount) do
    Moneta.Cldr.Number.to_string!(amount.quantity.floating_point, currency: "EUR")
  end
end
