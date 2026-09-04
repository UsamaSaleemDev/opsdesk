defmodule OpsDeskWeb.PageController do
  use OpsDeskWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
