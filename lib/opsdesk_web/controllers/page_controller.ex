defmodule OpsDeskWeb.PageController do
  use OpsDeskWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def not_found(conn, _params) do
    conn
    |> put_status(:not_found)
    |> put_view(html: OpsDeskWeb.ErrorHTML)
    |> render(:"404")
  end
end
