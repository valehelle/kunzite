defmodule KunziteWeb.BlogsResolver do
  alias Kunzite.Blogs

  def get_post(_root, %{slug: slug}, _info) do
    {:ok, Blogs.get_post_from_slug(slug)}
  end

  def list_post(_root, _param, _info) do
    {:ok, Blogs.list_post()}
  end
end
