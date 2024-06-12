defmodule PhoenixTodoWeb.TodoControllerTest do
  use PhoenixTodoWeb.ConnCase

  @valid_attrs %{title: "Buy milk", description: "2% or whole?"}

  test "GET /api/tasks", %{conn: conn} do
    conn = get(conn, "/api/tasks")
    assert json_response(conn, 200)
  end

  test "GET /api/tasks?=title=Buy milk&description=2% or whole?", %{conn: conn} do
    conn = post(conn, "/api/tasks", todo: @valid_attrs)
    conn = get(conn, "/api/tasks?title=Buy milk&description=2% or whole?")

    task =
      Enum.find(json_response(conn, 200)["data"], fn task ->
        task["title"] == "Buy milk" and task["description"] == "2% or whole?"
      end)

    assert task["title"] == "Buy milk" and task["description"] == "2% or whole?"
  end

  test "POST /api/tasks/", %{conn: conn} do
    conn = post(conn, "/api/tasks", todo: @valid_attrs)
    assert json_response(conn, 201)["data"]["title"] == "Buy milk"
  end
end
