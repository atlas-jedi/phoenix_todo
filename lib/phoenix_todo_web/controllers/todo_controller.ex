defmodule PhoenixTodoWeb.TodoController do
  use PhoenixTodoWeb, :controller

  alias PhoenixTodo.Todo

  action_fallback PhoenixTodoWeb.FallbackController

  def index(conn, _params) do
    tasks = Todo.list_tasks()
    render(conn, :index, todo: tasks)
  end

  # def create(conn, %{"todo" => todo_params}) do
  #   case Todo.create_task(todo_params) do
  #     {:ok, task} ->
  #       conn
  #       |> put_status(:created)
  #       |> put_view(PhoenixTodoWeb.ChangesetView)
  #       |> render("show.json", task: task)

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       conn
  #       |> put_status(:unprocessable_entity)
  #       |> put_view(json: PhoenixTodoWeb.ChangesetView)
  #       |> render("error.json", changeset: changeset)
  #   end
  # end
end
