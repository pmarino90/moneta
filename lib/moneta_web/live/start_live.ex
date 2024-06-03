defmodule MonetaWeb.StartLive do
  use MonetaWeb, :live_view_no_layout

  import MonetaWeb.CoreComponents

  alias Moneta.Session

  def render(assigns) do
    ~H"""
    <main class="p-5">
      <.flash_group flash={@flash} />

      <h1 class="text-lg">Moneta</h1>
      <p class="text-slate-700">
        Please selecte the ledger file you wish to use.
      </p>

      <.simple_form for={@form} phx-submit="save">
        <.input field={@form[:ledger_file]} label="Ledger file" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: to_form(%{"ledger_file" => nil}))

    {:ok, socket}
  end

  def handle_event("save", params, socket) do
    ledger_file = params["ledger_file"]

    case File.stat(ledger_file) do
      {:ok, _stat} ->
        Session.set_current_ledger(ledger_file)

        socket =
          socket
          |> push_navigate(to: ~p"/reports/income_statement")

        {:noreply, socket}

      {:error, _err} ->
        socket =
          socket
          |> put_flash(:error, "Selected path is invalid")

        {:noreply, socket}
    end
  end
end
