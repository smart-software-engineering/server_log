defmodule ServerLogWeb.ServerLoggerLive do
  use ServerLogWeb, :live_view

  alias ServerLog.ServerLogger

  @impl true
  def render(assigns) do
    ~H"""
    <h1><%= @page_title %></h1>
    <button phx-click="server_log">Click me</button>
    <ul class="list-disc" phx-update="stream" id="messages">
      <li :for={{dom_id, msg} <- @streams.messages} id={dom_id}><%= msg.level %></li>
    </ul>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> stream(:messages, []) |> assign(:page_title, "Server Logger")}
  end

  @impl true
  def handle_event("server_log", _, socket) do
    {:ok, level} = ServerLogger.log_a_message()

    random_id = for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>

    {:noreply, stream_insert(socket, :messages, %{id: random_id, level: level}, at: 0)}
  end
end
