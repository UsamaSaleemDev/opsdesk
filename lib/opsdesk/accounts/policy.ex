defmodule OpsDesk.Accounts.Policy do
  @moduledoc """
  Code-based authorization for OpsDesk.

  Roles are a fixed enum on `users`. Permission rules live here, not in the
  database. Unknown actions are denied (fail closed).
  """

  alias OpsDesk.Accounts.User

  @logged_in_roles [:employee, :hr, :finance, :management]

  @doc """
  Returns whether `user` may perform `action`.
  """
  def can?(%User{role: :admin}, _action), do: true

  def can?(%User{role: :ceo}, :view_financials), do: true

  def can?(%User{role: role}, :view_own_assets) when role in @logged_in_roles, do: true

  def can?(%User{role: role}, :raise_request) when role in @logged_in_roles, do: true

  def can?(_user, _action), do: false
end
