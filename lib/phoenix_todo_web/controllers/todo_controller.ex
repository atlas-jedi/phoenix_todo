defmodule PhoenixTodoWeb.TodoController do
  use PhoenixTodoWeb, :controller

  alias PhoenixTodo.Todo
  alias PhoenixTodo.Todo.Task

  action_fallback PhoenixTodoWeb.FallbackController

  def index(conn, _params) do
    tasks = Todo.list_tasks()
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
end
