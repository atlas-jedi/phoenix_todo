defmodule PhoenixTodoWeb.TodoLive do
  alias PhoenixTodo.Todo
  use PhoenixTodoWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
      <div class="min-h-screen flex flex-col items-center bg-gray-100 py-10">
      <h1 class="text-4xl font-bold text-blue-600 mb-10">Phoenix ToDo List</h1>
      <div class="w-full max-w-md bg-white rounded-lg shadow-lg p-6">
        <form phx-submit="save">
          <div class="mb-4">
            <label class="block text-gray-700">Title</label>
            <input
              type="text"
              name="task[title]"
              class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              placeholder="Título da tarefa"
            />
          </div>
          <div class="mb-4">
            <label class="block text-gray-700">Description</label>
            <textarea
              name="task[description]"
              class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600"
              placeholder="Descrição da tarefa a ser feita"
            ></textarea>
          </div>
          <div class="flex justify-end">
            <button
              type="submit"
              class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
            >
              Add Task
            </button>
          </div>
        </form>
      </div>
      <div class="w-full max-w-md mt-10">
        <h2 class="text-2xl font-bold text-gray-700 mb-4">Tasks</h2>
        <ul class="space-y-4">
          <%= for task <- Enum.sort_by(@tasks, &(&1.completed_at == nil), :desc) do %>
            <li class="bg-white p-4 rounded-lg shadow flex justify-between items-center">
              <div>
                <h3 class="text-lg font-semibold text-gray-800"><%= task.title %></h3>
                <p class="text-gray-600"><%= task.description %></p>
                <%= if task.completed_at do %>
                  <div class="mt-3 py-1 mr-2 border-t border-gray-300"></div>
                  <p class="text-gray-600">
                    Concluído em: 11/07/2024
                  </p>
                <% end %>
              </div>
              <div>
                <button class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 ml-2">
                  <%= if task.completed_at do %>Desfazer<% else %>Completar<% end %>
                </button>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, tasks: Todo.list_tasks(), new_task: %{})}
  end

  @impl true
  def handle_event("save", %{"task" => task_params}, socket) do
    case Todo.create_task(task_params) do
      {:ok, _task} ->
        {:noreply, assign(socket, tasks: Todo.list_tasks(), new_task: %{})}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, new_task: changeset)}
    end
  end
end
