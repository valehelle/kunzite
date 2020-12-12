defmodule KunziteWeb.Schema do
  use Absinthe.Schema

  alias KunziteWeb.AccountsResolver
  alias KunziteWeb.BlogsResolver

  object :user do
    field :email, non_null(:string)
    field :post, list_of(:post)
  end

  object :post do
    field :id, non_null(:id)
    field :title, non_null(:string)
    field :content, non_null(:string)
    field :slug, :string
    field :author, :user
  end

  query do
    @desc "Get post"
    field :post, non_null(:post) do
     arg :slug, non_null(:string)
     resolve(&BlogsResolver.get_post/3)
    end



    @desc "Get a user of the blog"
    field :user, :user do
      arg :id, non_null(:string)
      resolve &AccountsResolver.find_user/3
    end
  end


end
