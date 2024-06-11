defmodule PhoenixTodo.TodoTest do
  use PhoenixTodo.DataCase

  alias PhoenixTodo.Todo

  describe "tasks" do
    alias PhoenixTodo.Todo.Task

    import PhoenixTodo.TodoFixtures

    @invalid_attrs %{
      description: nil,
      title: nil,
      completed_at: nil,
      inserted_at: nil,
      updated_at: nil
    }

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Todo.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Todo.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{
        description: "some description",
        title: "some title",
        completed_at: ~U[2024-06-10 14:10:00Z],
        inserted_at: ~U[2024-06-10 14:10:00Z],
        updated_at: ~U[2024-06-10 14:10:00Z]
      }

      assert {:ok, %Task{} = task} = Todo.create_task(valid_attrs)
      assert task.description == "some description"
      assert task.title == "some title"
      assert task.completed_at == ~U[2024-06-10 14:10:00Z]
      assert task.inserted_at == ~U[2024-06-10 14:10:00Z]
      assert task.updated_at == ~U[2024-06-10 14:10:00Z]
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todo.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        completed_at: ~U[2024-06-11 14:10:00Z],
        inserted_at: ~U[2024-06-11 14:10:00Z],
        updated_at: ~U[2024-06-11 14:10:00Z]
      }

      assert {:ok, %Task{} = task} = Todo.update_task(task, update_attrs)
      assert task.description == "some updated description"
      assert task.title == "some updated title"
      assert task.completed_at == ~U[2024-06-11 14:10:00Z]
      assert task.inserted_at == ~U[2024-06-11 14:10:00Z]
      assert task.updated_at == ~U[2024-06-11 14:10:00Z]
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Todo.update_task(task, @invalid_attrs)
      assert task == Todo.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Todo.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Todo.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Todo.change_task(task)
    end
  end
end
