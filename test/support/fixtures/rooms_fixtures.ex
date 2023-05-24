defmodule ChatApp.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ChatApp.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> ChatApp.Rooms.create_room()

    room
  end
end
