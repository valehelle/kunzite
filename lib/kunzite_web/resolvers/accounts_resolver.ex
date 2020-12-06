defmodule KunziteWeb.AccountsResolver do
  alias Kunzite.Accounts

  def find_user(_root, %{id: id}, _info) do
    {:ok, Accounts.get_user!(id)}
  end
end
