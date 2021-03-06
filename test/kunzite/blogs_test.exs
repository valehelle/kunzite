defmodule Kunzite.BlogsTest do
  use Kunzite.DataCase

  alias Kunzite.Blogs
  alias Kunzite.Blogs.Post
  import Kunzite.AccountsFixtures
  import Kunzite.PostsFixtures
  
  
  describe "posts" do

    
    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}


    
    test "list_post/1 returns list of post with given id" do
      {post, user}  = post_fixture(@valid_attrs)
      assert Blogs.list_post(user.id) == [post]
    end

    test "list_post/1 returns empty list with given id" do
      user = user_fixture()
      assert Blogs.list_post(user.id) == []
    end

    test "get_post!/1 returns the post with given id" do
      {post, _user}  = post_fixture(@valid_attrs )
      assert Blogs.get_post!(post.id) == post
    end

    test "get_post_from_slug!/1 returns the post with given slug" do
      {post, _user}  = post_fixture(@valid_attrs )
      assert Blogs.get_post_from_slug(post.slug) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()
      assert {:ok, %Post{} = post} = Blogs.create_post(@valid_attrs, user)
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Blogs.create_post(@invalid_attrs, user)
    end

    test "update_post/2 with valid data updates the post" do
      {post, user}  = post_fixture(@valid_attrs )
      assert {:ok, %Post{} = post} = Blogs.update_post(post, @update_attrs, user)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      {post, user}  = post_fixture(@valid_attrs )
      assert {:error, %Ecto.Changeset{}} = Blogs.update_post(post, @invalid_attrs, user)
      assert post == Blogs.get_post!(post.id)
    end

    test "update_post/2 with different author" do
      {post, _user}  = post_fixture(@valid_attrs )
      different_user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Blogs.update_post(post, @update_attrs, different_user)
      assert post == Blogs.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      {post, _user}  = post_fixture(@valid_attrs )
      assert {:ok, %Post{}} = Blogs.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blogs.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      {post, _user}  = post_fixture(@valid_attrs )
      assert %Ecto.Changeset{} = Blogs.change_post(post)
    end

    test "get_count/1 returns a number of post belong to user" do
      {post, user}  = post_fixture(%{content: "some content", title: "some title 1"})
      {post, user}  = post_fixture(%{content: "some content", title: "some title 2"}, user)
      {post, user}  = post_fixture(%{content: "some content", title: "some title 3"}, user)
      assert 3 = Blogs.get_count(user.id)
    end

    test "list_post_with_pagination/2 returns a list of latest 3 post with pagination" do
      {_post, user}  = post_fixture(%{content: "some content", title: "some title 1"})
      {_post, user}  = post_fixture(%{content: "some content", title: "some title 2"}, user)
      {%{id: post_3_id}, user}  = post_fixture(%{content: "some content", title: "some title 3"}, user)
      {%{id: post_4_id}, user}  = post_fixture(%{content: "some content", title: "some title 4"}, user)
      {%{id: post_5_id}, user}  = post_fixture(%{content: "some content", title: "some title 5"}, user)
      {:ok, %{edges: [%{node: node_post_5},%{node: node_post_4},%{node: node_post_3}]}} = Blogs.list_post_with_pagination(user.id, %{first: 3})
      assert post_5_id == node_post_5.id
      assert post_4_id == node_post_4.id
      assert post_3_id == node_post_3.id
    end

  end
end
