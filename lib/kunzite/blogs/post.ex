defmodule Kunzite.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kunzite.Accounts.User

  schema "posts" do
    field :content, :string
    field :title, :string
    belongs_to :author, User
    
    timestamps()
  end

  @doc false
  def create_changeset(post, attrs, user) do
    post
    |> cast(attrs, [:title, :content])
    |> put_assoc(:author, user)
    |> validate_required([:title, :content, :author])
  end

  def update_changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
