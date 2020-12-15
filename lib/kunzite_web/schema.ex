defmodule KunziteWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern

  alias KunziteWeb.AccountsResolver
  alias KunziteWeb.BlogsResolver
  alias Kunzite.Accounts

  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  

  connection node_type: :post

  object :user do
    field :email, non_null(:string)
    field :count, :integer do
      resolve &BlogsResolver.get_count/3
    end

    connection field :posts, node_type: :post do
      resolve &BlogsResolver.list_post/2
    end
  end

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :content, non_null(:string)
    field :slug, :string
    field :author, list_of(:user), resolve: dataloader(Accounts)
  end

  query do
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
  Map.put(ctx, :loader, loader)
end

def plugins do
  [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
end



end
