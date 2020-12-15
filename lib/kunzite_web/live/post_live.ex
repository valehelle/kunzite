defmodule KunziteWeb.PostLive do
  use KunziteWeb, :live_view
  alias Kunzite.Blogs
  alias Kunzite.Blogs.Post
  alias Kunzite.Accounts
  
  @impl true
  def mount(%{"post_id" => post_id}, %{"user_token" => user_token}, socket) do
    user = Accounts.get_user_by_session_token(user_token)
    post = Blogs.get_post!(post_id)
    changeset = Post.update_changeset(post, %{})
    {:ok, assign(socket, changeset: changeset, post: post, current_user: user)}
  end

  @impl true
  def handle_event("save", %{"post" => post_params}, socket) do
    current_user = socket.assigns.current_user
    post = socket.assigns.post
    case Blogs.update_post(post, post_params, current_user) do
      {:ok, post } -> 
        changeset = Post.update_changeset(post, %{})
        {:noreply, assign(socket, changeset: changeset)}
      {:error, changeset} -> 
        {:noreply, assign(socket, changeset: changeset)}
    end

end


end
