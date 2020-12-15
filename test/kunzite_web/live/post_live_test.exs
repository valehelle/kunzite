defmodule KunziteWeb.PostLiveTest do
  use KunziteWeb.ConnCase
  alias Kunzite.Accounts
  import Phoenix.LiveViewTest
  import Kunzite.PostsFixtures


    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}


  setup %{conn: conn} do

    {post, user} = post_fixture(@valid_attrs)

    token = Accounts.generate_user_session_token(user)

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
    assert render_change(post_live, :save, %{post:  @update_attrs}) =~  @update_attrs.title
  end
end
