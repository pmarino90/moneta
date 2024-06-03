defmodule MonetaWeb.SettingsLive do
  alias Moneta.Session

  use MonetaWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="mx-auto w-2/4">
      <h1 class="font-bold text-lg">Settings</h1>

      <.simple_form for={@form} phx-submit="save">
        <h2 class="text-slate-700">Ledger</h2>
        <.input field={@form[:ledger_file]} label="Ledger file" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(form: to_form(%{"ledger_file" => Session.get_current_ledger()}))

    {:ok, socket}
  end

  def handle_event("save", params, socket) do
    ledger_file = params["ledger_file"]

    case File.stat(ledger_file) do
      {:ok, _stat} ->
        Session.set_current_ledger(ledger_file)

        socket =
          socket
          |> put_flash(:info, "Settings saved")

        {:noreply, socket}

      {:error, _err} ->
        socket =
          socket
          |> put_flash(:error, "Selected path is invalid")

        {:noreply, socket}
    end
  end
end
