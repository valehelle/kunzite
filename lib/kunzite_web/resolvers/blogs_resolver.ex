defmodule KunziteWeb.BlogsResolver do
  alias Kunzite.Blogs
  alias Kunzite.Accounts

  def get_post(_root, %{slug: slug}, _info) do
    {:ok, Blogs.get_post_from_slug(slug)}
  end
end
