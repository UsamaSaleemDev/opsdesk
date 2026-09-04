defmodule OpsDesk.Accounts.PolicyTest do
  use OpsDesk.DataCase, async: true

  alias OpsDesk.Accounts.Policy
  alias OpsDesk.Accounts.User

  defp user(role), do: %User{role: role}

  describe "can?/2" do
    test "admin is allowed every action" do
      admin = user(:admin)

      assert Policy.can?(admin, :view_own_assets)
      assert Policy.can?(admin, :raise_request)
      assert Policy.can?(admin, :view_financials)
      assert Policy.can?(admin, :anything_else)
    end

    test "ceo is allowed only view_financials" do
      ceo = user(:ceo)

      assert Policy.can?(ceo, :view_financials)
      refute Policy.can?(ceo, :view_own_assets)
      refute Policy.can?(ceo, :raise_request)
      refute Policy.can?(ceo, :anything_else)
    end

    test "employee, hr, finance, and management can view own assets and raise requests" do
      for role <- [:employee, :hr, :finance, :management] do
        actor = user(role)

        assert Policy.can?(actor, :view_own_assets)
        assert Policy.can?(actor, :raise_request)
        refute Policy.can?(actor, :view_financials)
        refute Policy.can?(actor, :anything_else)
      end
    end

    test "denies missing users and unknown actions by default" do
      refute Policy.can?(nil, :view_own_assets)
      refute Policy.can?(%User{role: :employee}, :not_a_real_action)
    end
  end
end
