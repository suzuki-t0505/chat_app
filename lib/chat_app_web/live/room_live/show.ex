defmodule ChatAppWeb.RoomLive.Show do
  use ChatAppWeb, :live_view

  alias ChatApp.Rooms
  alias ChatApp.Accounts
  alias ChatApp.Messages.Message

  @impl true
  def mount(_params, session, socket) do
    account = Accounts.get_account_by_session_token(session["account_token"])

    {:ok, assign(socket, :current_account, account)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    socket =
      if room = Rooms.get_room!(String.to_integer(id), socket.assigns.current_account.id) do
        if connected?(socket) do
          subscribe(room)
        end

        socket
        |> assign(:page_title, room.name)
        |> assign(:room, room)
        |> assign(:messages, Rooms.list_messages(room.id))
        |> assign_form(Rooms.change_message(%Message{}))
      else
        socket
        |> put_flash(:error, "Not join room.")
        |> redirect(to: ~p"/rooms")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({ChatAppWeb.RoomLive.FormComponent, {:saved, room}}, socket) do
    broadcast(room, :update_room_name)
    {:noreply, socket}
  end

  def handle_info({:update_room_name, room}, socket) do
    socket =
      update(socket, :room, & %{&1 | name: room.name})

    {:noreply, socket}
  end

  def handle_info({:send_message, message}, socket) do
    socket =
      update(socket, :messages, & &1 ++ [message])

    {:noreply, socket}
  end

  @impl true
  def handle_event("send_message", %{"message" => params}, socket) do
    params = Map.merge(params, %{"account_id" => socket.assigns.current_account.id, "room_id" => socket.assigns.room.id})
    socket =
      case Rooms.create_message(params) do
        {:ok, message} ->
          broadcast(message, :send_message)

          assign_form(socket, Rooms.change_message(%Message{}))
        {:error, cs} ->
          assign_form(socket, cs)
      end

    {:noreply, socket}
  end

  defp assign_form(socket, cs) do
    assign(socket, :message_form, to_form(cs))
  end

  defp subscribe(room) do
    Phoenix.PubSub.subscribe(ChatApp.PubSub, "room_#{room.id}")
  end

  # def broadcast({:error, _} = error, _event), do: error

  defp broadcast(message, :send_message) do
    Phoenix.PubSub.broadcast(ChatApp.PubSub, "room_#{message.room_id}", {:send_message, message})
  end

  defp broadcast(room, :update_room_name) do
    Phoenix.PubSub.broadcast(ChatApp.PubSub, "room_#{room.id}", {:update_room_name, room})
  end
end
