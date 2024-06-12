defmodule PhoenixTodoWeb.TodoJSON do
  alias PhoenixTodo.Todo.Task

  @doc """
  Renders a list of tasks.
  """
  def index(%{todo: tasks}) do
    %{data: for(task <- tasks, do: data(task))}
  end

  @doc """
  Renders a single task.
  """
  def show(%{todo: task}) do
    %{data: data(task)}
  end

  defp data(%Task{} = task) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      completed_at: task.completed_at
    }
  end
end
