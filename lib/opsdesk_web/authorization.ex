defmodule OpsDeskWeb.Authorization do
  @moduledoc """
  Role-gating helpers for routes and templates.

  Permission rules live in `OpsDesk.Accounts.Policy`. This module only applies
  them at the web layer. Do not attach these plugs to routes until a feature
  ticket needs them.

  ## Plug (controllers)

      plug :require_permission, :view_financials

  or:

      plug OpsDeskWeb.Authorization, :view_financials

  ## LiveView

      live_session :finance,
        on_mount: [{OpsDeskWeb.Authorization, {:require, :view_financials}}] do
        live "/reports", ReportLive
      end

  ## Templates

      <button :if={can?(@current_scope, :raise_request)}>New request</button>
  """

  use OpsDeskWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias OpsDesk.Accounts.{Policy, Scope, User}

  @behaviour Plug

  def init(action) when is_atom(action), do: action

  def call(conn, action) when is_atom(action), do: require_permission(conn, action)

  @doc """
  Returns whether the given user or scope may perform `action`.
  """
  def can?(%Scope{user: user}, action), do: can?(user, action)
  def can?(%User{} = user, action), do: Policy.can?(user, action)
  def can?(_user, _action), do: false

  @doc """
  Plug that halts and redirects when the current user cannot perform `action`.
  """
  def require_permission(conn, action) when is_atom(action) do
    if can?(conn.assigns[:current_scope], action) do
      conn
    else
      conn
      |> put_flash(:error, "You are not allowed to access this page.")
      |> redirect(to: ~p"/")
      |> halt()
    end
  end

  @doc false
  def on_mount({:require, action}, _params, _session, socket) do
    if can?(socket.assigns[:current_scope], action) do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You are not allowed to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/")

      {:halt, socket}
    end
  end
end
