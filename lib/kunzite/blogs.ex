defmodule Kunzite.Blogs do
  @moduledoc """
  The Blogs context.
  """

  import Ecto.Query, warn: false
  alias Kunzite.Repo

  alias Kunzite.Blogs.Post



  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id) |> Repo.preload([:author])

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value}, user)
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, user) do
    %Post{}
    |> Post.create_changeset(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value}, user)
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value}, user)
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs, user) do
    changeset = Post.update_changeset(post, attrs)
    case is_author(post, user) do
     true ->
       Repo.update(changeset)
     false ->
       changeset = Ecto.Changeset.add_error(changeset, :author, "Invalid")
       {:error, changeset}
    end
  end
  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.update_changeset(post, attrs)
  end

  defp is_author(post,user) do
   post.author_id == user.id
  end
end