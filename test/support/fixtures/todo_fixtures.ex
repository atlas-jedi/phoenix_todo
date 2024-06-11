defmodule PhoenixTodo.TodoFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixTodo.Todo` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed_at: ~U[2024-06-10 14:10:00Z],
        inserted_at: ~U[2024-06-10 14:10:00Z],
        description: "some description",
        title: "some title",
        updated_at: ~U[2024-06-10 14:10:00Z]
      })
      |> PhoenixTodo.Todo.create_task()

    task
  end
end
