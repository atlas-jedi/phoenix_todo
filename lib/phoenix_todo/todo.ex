defmodule PhoenixTodo.Todo do
  @moduledoc """
  The Todo context.
  """

  import Ecto.Query, warn: false
  alias PhoenixTodo.Repo

  alias PhoenixTodo.Todo.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

      iex> list_tasks(%{"title" => "Task 1"})
      [%Task{title: "Task 1"}, ...]

      iex> list_tasks(%{"description" => "Important"})
      [%Task{description: "Important task"}, ...]

  """
  def list_tasks(params \\ %{}) do
    Task
    |> filter_by_title(params["title"])
    |> filter_by_description(params["description"])
    |> Repo.all()
  end

  defp filter_by_title(query, title) do
    from t in query, where: ilike(t.title, ^"%#{title}%")
  end

  defp filter_by_description(query, description) do
    from t in query, where: ilike(t.description, ^"%#{description}%")
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end

  @doc """
  Completes a task.

  If the task is already completed, it will be marked as incomplete.

  ## Examples

      iex> complete_task(task)
      {:ok, %Task{}}

      iex> complete_task(task)
      {:error, %Ecto.Changeset{}}
  """
  def complete_task(%Task{} = task) do
    new_completed_at =
      if task.completed_at do
        nil
      else
        DateTime.utc_now()
      end

    task
    |> Task.changeset(%{completed_at: new_completed_at})
    |> Repo.update()
  end
end
