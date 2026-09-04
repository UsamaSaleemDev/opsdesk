defmodule OpsDeskWeb.AuthorizationTest do
  use OpsDeskWeb.ConnCase, async: true

  alias Phoenix.LiveView
  alias OpsDesk.Accounts.Scope
  alias OpsDeskWeb.Authorization

  import OpsDesk.AccountsFixtures

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, OpsDeskWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{conn: conn}
  end

  describe "can?/2" do
    test "uses the policy for a user and a scope" do
      employee = user_fixture()
      {:ok, admin} = OpsDesk.Accounts.update_user_role(user_fixture(), :admin)

      assert Authorization.can?(employee, :raise_request)
      assert Authorization.can?(Scope.for_user(employee), :raise_request)
      refute Authorization.can?(employee, :view_financials)
      assert Authorization.can?(admin, :view_financials)
      refute Authorization.can?(nil, :raise_request)
    end
  end

  describe "require_permission/2" do
    test "allows the request when the user can perform the action", %{conn: conn} do
      {:ok, admin} = OpsDesk.Accounts.update_user_role(user_fixture(), :admin)

      conn =
        conn
        |> assign(:current_scope, Scope.for_user(admin))
        |> fetch_flash()
        |> Authorization.require_permission(:view_financials)

      refute conn.halted
    end

    test "redirects when the user cannot perform the action", %{conn: conn} do
      employee = user_fixture()

      conn =
        conn
        |> assign(:current_scope, Scope.for_user(employee))
        |> fetch_flash()
        |> Authorization.require_permission(:view_financials)

      assert conn.halted
      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "You are not allowed to access this page."
    end

    test "redirects guests", %{conn: conn} do
      conn =
        conn
        |> assign(:current_scope, nil)
        |> fetch_flash()
        |> Authorization.require_permission(:raise_request)

      assert conn.halted
      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "on_mount {:require, action}" do
    defp socket(scope) do
      %LiveView.Socket{
        endpoint: OpsDeskWeb.Endpoint,
        assigns: %{current_scope: scope, __changed__: %{}, flash: %{}}
      }
    end

    test "continues when the user is allowed" do
      {:ok, admin} = OpsDesk.Accounts.update_user_role(user_fixture(), :admin)

      assert {:cont, _socket} =
               Authorization.on_mount(
                 {:require, :view_financials},
                 %{},
                 %{},
                 socket(Scope.for_user(admin))
               )
    end

    test "halts when the user is not allowed" do
      employee = user_fixture()

      assert {:halt, socket} =
               Authorization.on_mount(
                 {:require, :view_financials},
                 %{},
                 %{},
                 socket(Scope.for_user(employee))
               )

      assert Phoenix.Flash.get(socket.assigns.flash, :error) ==
               "You are not allowed to access this page."
    end
  end
end
