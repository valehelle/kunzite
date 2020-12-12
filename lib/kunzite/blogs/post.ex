defmodule Kunzite.Blogs.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kunzite.Accounts.User

  schema "posts" do
    field :content, :string
    field :title, :string
    field :slug, :string
    belongs_to :author, User
    
    timestamps()
  end

  @doc false
  def create_changeset(post, attrs, user) do

    
    post
    |> cast(attrs, [:title, :content])
    |> put_assoc(:author, user)
    |> add_slug()
    |> validate_required([:title, :content, :author, :slug])
  end

  defp add_slug(%Ecto.Changeset{valid?: true, changes: %{title: title}} = changeset) do
    time = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    slug = Slug.slugify("#{title} #{time}")
    put_change(changeset, :slug, slug)
  end
  defp add_slug(changeset) do
    changeset
  end

  def update_changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
