defmodule KunziteWeb.PostController do
  use KunziteWeb, :controller
  alias Kunzite.Blogs
  alias Kunzite.Blogs.Post
  def index(conn, _params) do
    current_user = conn.assigns.current_user
    posts = Blogs.list_post(current_user.id)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    current_user = conn.assigns.current_user
    changeset = Post.create_changeset(%Post{}, %{}, current_user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    current_user = conn.assigns.current_user
    case Blogs.create_post(post_params, current_user) do
      {:ok, _post} ->
        redirect(conn, to: Routes.post_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end


  def show(conn, %{"post_id" => post_id}) do
    case Blogs.get_post!(post_id) do
      nil -> 
       redirect(conn, to: Routes.post_path(conn, :index))
      post -> render(conn, "show.html", post: post)
    end
  end


  def edit(conn, %{"post_id" => post_id}) do
    post = Blogs.get_post!(post_id)
    changeset = Post.update_changeset(post, %{})
    render(conn, "edit.html", changeset: changeset, post: post)
  end

  def update(conn, %{"post_id" => post_id, "post" => post_params}) do
    current_user = conn.assigns.current_user
    post = Blogs.get_post!(post_id)
    
    case Blogs.update_post(post, post_params, current_user) do
      {:ok, post } -> redirect(conn, to: Routes.post_path(conn, :show, post.id))
      {:error, changeset} -> 
      render(conn, "edit.html", changeset: changeset, post: post)
    end
  end

end