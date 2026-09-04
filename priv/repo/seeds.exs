# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Promote an existing user to admin (the user must already be registered):
#
#     OPSDESK_ADMIN_EMAIL=you@company.com mix run priv/repo/seeds.exs
#
# Or from IEx:
#
#     iex -S mix
#     user = OpsDesk.Accounts.get_user_by_email("you@company.com")
#     OpsDesk.Accounts.update_user_role(user, :admin)

email = System.get_env("OPSDESK_ADMIN_EMAIL")

if is_binary(email) and email != "" do
  case OpsDesk.Accounts.get_user_by_email(email) do
    nil ->
      IO.puts("No user found for #{email}. Register first, then re-run seeds.")

    user ->
      {:ok, user} = OpsDesk.Accounts.update_user_role(user, :admin)
      IO.puts("Promoted #{user.email} to #{user.role}.")
  end
end
