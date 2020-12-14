defmodule KunziteWeb.PostLiveTest do
  use KunziteWeb.ConnCase
  alias KunziteWeb.UserAuth
  import Phoenix.LiveViewTest
  import Kunzite.PostsFixtures

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, KunziteWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})
    {post, user} = post_fixture()
    conn = conn |> put_session(:user_return_to, "/posts/#{post.id}/edit") |> UserAuth.log_in_user(user)
    
    token =  get_session(conn, :user_token)
    conn = recycle(conn)
    conn =
      conn
      |> Map.replace!(:secret_key_base, KunziteWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    conn = conn |> put_session(:user_token, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
    
    %{conn: conn, post: post, user: user}
  end

  test "disconnected and connected render", %{conn: conn, post: post, user: user} do

    
    {:ok, post_live, disconnected_html} = live(conn, "/posts/#{post.id}/edit")
    assert disconnected_html =~ "Post"
    assert render(post_live) =~ "Post"
  end
  test "save title", %{conn: conn, post: post, user: user} do

    
    {:ok, post_live, disconnected_html} = live(conn, "/posts/#{post.id}/edit")
    assert render_change(post_live, :save, %{post: %{content: "some updated content", title: "some updated title"}}) =~ "some updated content"
  end
end
