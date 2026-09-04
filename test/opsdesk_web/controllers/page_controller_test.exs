defmodule OpsDeskWeb.PageControllerTest do
  use OpsDeskWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    html = html_response(conn, 200)

    assert html =~ "Welcome to OpsDesk"
    assert html =~ "Home"
    assert html =~ "Service desk and asset management"
    assert html =~ "phx:set-theme"
  end
end
