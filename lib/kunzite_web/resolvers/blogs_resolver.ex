defmodule KunziteWeb.BlogsResolver do
  alias Kunzite.Blogs
  alias Kunzite.Accounts

  def get_post(_root, %{slug: slug, id: id}, _info) do
    id = Accounts.decode_id(id)
    {:ok, Blogs.get_post_from_slug(slug, id)}
  end
end
