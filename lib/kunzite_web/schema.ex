defmodule KunziteWeb.Schema do
  use Absinthe.Schema
  alias KunziteWeb.AccountsResolver
  alias KunziteWeb.BlogsResolver
  alias Kunzite.Accounts
  alias Kunzite.Blogs
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  object :user do
    field :email, non_null(:string)
    field :post, list_of(:post), resolve: dataloader(Blogs)
  end

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :content, non_null(:string)
    field :slug, :string
    field :author, list_of(:user), resolve: dataloader(Accounts)
  end

  query do
    @desc "Get post"
    field :post, non_null(:post) do
     arg :slug, non_null(:string)
     resolve(&BlogsResolver.get_post/3)
    end

    @desc "List post"
    field :list_post, list_of(:post) do
     resolve(&BlogsResolver.list_post/3)
    end



    @desc "Get a user of the blog"
    field :user, :user do
      arg :id, non_null(:string)
      resolve &AccountsResolver.find_user/3
    end
  end

def context(ctx) do
  loader =
    Dataloader.new
    |> Dataloader.add_source(Accounts, Accounts.data())
    |> Dataloader.add_source(Blogs, Blogs.data())

  Map.put(ctx, :loader, loader)
end

def plugins do
  [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
end



end
