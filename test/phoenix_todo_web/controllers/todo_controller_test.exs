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

  describe "PUT /api/tasks:id endpoint" do
    test "PUT /api/tasks/:id with only title", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]
      conn = put(conn, "/api/tasks/#{task["id"]}", todo: %{title: "Buy soda"})

      assert json_response(conn, 200)["data"]["title"] == "Buy soda" and
               json_response(conn, 200)["data"]["description"] == "2% or whole?"
    end

    test "PUT /api/tasks/:id with only description", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]
      conn = put(conn, "/api/tasks/#{task["id"]}", todo: %{description: "300ml or 1l?"})

      assert json_response(conn, 200)["data"]["title"] == "Buy milk" and
               json_response(conn, 200)["data"]["description"] == "300ml or 1l?"
    end

    test "PUT /api/tasks/:id with title and description", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]

      conn =
        put(conn, "/api/tasks/#{task["id"]}",
          todo: %{title: "Buy soda", description: "300ml or 1l?"}
        )

      assert json_response(conn, 200)["data"]["title"] == "Buy soda" and
               json_response(conn, 200)["data"]["description"] == "300ml or 1l?"
    end
  end
end
