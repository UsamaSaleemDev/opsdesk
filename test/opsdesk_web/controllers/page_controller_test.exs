defmodule OpsDeskWeb.PageControllerTest do
  use OpsDeskWeb.ConnCase, async: true

  import OpsDesk.AccountsFixtures

  describe "GET /" do
    test "guests see Register and Log in", %{conn: conn} do
      conn = get(conn, ~p"/")
      html = html_response(conn, 200)

      assert html =~ "Welcome to OpsDesk"
      assert html =~ "Home"
      assert html =~ "Log in to continue."
      assert html =~ "Register"
      assert html =~ "Log in"
      assert html =~ ~p"/users/register"
      assert html =~ ~p"/users/log-in"
      assert html =~ "Service desk and asset management"
      assert html =~ "phx:set-theme"
      refute html =~ ~p"/users/log-out"
      refute html =~ ~p"/users/settings"
    end

    test "logged-in users see their email, Settings, and Log out", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> log_in_user(user)
        |> get(~p"/")

      html = html_response(conn, 200)

      assert html =~ "Welcome to OpsDesk"
      assert html =~ "You are signed in."
      assert html =~ user.email
      assert html =~ ~p"/users/settings"
      assert html =~ ~p"/users/log-out"
      refute html =~ "Log in to continue."
      refute html =~ ~p"/users/register"
    end
  end

  describe "unknown routes" do
    test "GET /users renders the 404 page", %{conn: conn} do
      conn = get(conn, "/users")
      html = html_response(conn, 404)

      assert html =~ "Page not found"
      assert html =~ "Back home"
      refute html =~ "NoRouteError"
    end

    test "unknown nested paths render the 404 page", %{conn: conn} do
      conn = get(conn, "/does-not-exist/anywhere")
      html = html_response(conn, 404)

      assert html =~ "Page not found"
    end
  end
end
