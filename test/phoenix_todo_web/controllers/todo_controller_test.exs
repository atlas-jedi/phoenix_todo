defmodule PhoenixTodoWeb.TodoControllerTest do
  use PhoenixTodoWeb.ConnCase

  @valid_attrs %{title: "Buy milk", description: "2% or whole?"}
  @invalid_attrs %{title: "Buy milk", description: nil}

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

  describe "POST /api/tasks/ endpoint" do
    test "POST /api/tasks/ with valid attrs", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      assert json_response(conn, 201)["data"]["title"] == "Buy milk"
    end

    test "POST /api/tasks/ with invalid attrs", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"]["description"] == ["can't be blank"]
    end
  end

  describe "DELETE /api/tasks/:id endpoint" do
    test "DELETE /api/tasks/:id with existent id", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]
      conn = delete(conn, "/api/tasks/#{task["id"]}")
      assert json_response(conn, 200)["data"]["title"] == "Buy milk"
    end

    test "DELETE /api/tasks/:id with non-existent id", %{conn: conn} do
      conn = delete(conn, "/api/tasks/1")
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
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

    test "PUT /api/tasks/:id with invalid attrs", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]
      conn = put(conn, "/api/tasks/#{task["id"]}", todo: @invalid_attrs)

      assert json_response(conn, 422)["errors"]["description"] == ["can't be blank"]
    end

    test "PUT /api/tasks/:id with non-existent id", %{conn: conn} do
      conn = put(conn, "/api/tasks/1", todo: @valid_attrs)
      assert json_response(conn, 404)["errors"]["detail"] == "Not Found"
    end
  end

  describe "PATCH /api/tasks:id/complete endpoint" do
    test "PATCH /api/tasks:id/complete on an uncompleted task", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]
      conn = patch(conn, "/api/tasks/#{task["id"]}/complete")

      assert json_response(conn, 200)["data"]["completed_at"] != nil
    end

    test "PATCH /api/tasks:id/complete on a completed task", %{conn: conn} do
      conn = post(conn, "/api/tasks", todo: @valid_attrs)
      task = json_response(conn, 201)["data"]
      conn = patch(conn, "/api/tasks/#{task["id"]}/complete")
      conn = patch(conn, "/api/tasks/#{task["id"]}/complete")

      assert json_response(conn, 200)["data"]["completed_at"] == nil
    end
  end
end
