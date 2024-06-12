defmodule PhoenixTodo.Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :description, :string
    field :title, :string
    field :completed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :completed_at, :inserted_at, :updated_at])
    |> validate_required([:title, :description])
  end
end
