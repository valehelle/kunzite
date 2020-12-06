defmodule KunziteWeb.BlogsResolver do
  alias Kunzite.Blogs

  def get_post(_root, %{id: id}, _info) do
    {:ok, Blogs.get_post!(id)}
  end
end
