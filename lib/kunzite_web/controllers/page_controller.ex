defmodule KunziteWeb.PageController do
  use KunziteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end


end