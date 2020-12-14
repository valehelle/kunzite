defmodule Kunzite.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kunzite.Accounts` context.
  """
  alias Kunzite.Blogs

  import Kunzite.AccountsFixtures
  @valid_attrs %{content: "some content", title: "some title"}

    def post_fixture(attrs \\ %{}) do
      user = user_fixture()
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Blogs.create_post(user)

      {post, user}
    end
end
