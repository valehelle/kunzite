defmodule KunziteWeb.Context do
  @behaviour Plug



  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
   %{current_user: conn.assigns.current_user}
  end


end