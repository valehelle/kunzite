defmodule KunziteWeb.AccountsResolver do
  alias Kunzite.Accounts

  def find_user(_root, %{id: id}, info) do
    %{context: context} = info
    IO.inspect context
    {:ok, Accounts.get_user!(id)}
  end
end
