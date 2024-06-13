defmodule PhoenixTodoWeb.TodoController do
  use PhoenixTodoWeb, :controller

  alias PhoenixTodo.Todo
  alias PhoenixTodo.Todo.Task

  action_fallback PhoenixTodoWeb.FallbackController

  def index(conn, params) do
    tasks = Todo.list_tasks(params)
    render(conn, :index, todo: tasks)
  end

  def create(conn, %{"todo" => todo_params}) do
    with {:ok, %Task{} = task} <- Todo.create_task(todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/tasks/#{task}")
      |> render(:show, todo: task)
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{} = task} <- Todo.update_task(task, todo_params) do
      render(conn, :show, todo: task)
    end
  end

  def complete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{} = task} <- Todo.complete_task(task) do
      render(conn, :show, todo: task)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Todo.get_task!(id)

    with {:ok, %Task{}} <- Todo.delete_task(task) do
      conn
      |> put_status(:ok)
      |> render(:show, todo: task)
    end
  end
end
