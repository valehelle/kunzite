defmodule KunziteWeb.BlogsResolver do
  alias Kunzite.Blogs

  def get_post(_root, %{slug: slug}, _info) do
    {:ok, Blogs.get_post_from_slug(slug)}
  end

  def list_post(pagination_args, %{source: user}) do 
      Blogs.list_post_with_pagination(user.id, pagination_args)
  end

  def get_count(user, _, _) do 
      {:ok, Blogs.get_count(user.id)}
  end
end
