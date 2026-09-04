# OpsDesk

Multi-tenant service desk and asset management. This repository currently contains the Phoenix 1.8 LiveView skeleton (PostgreSQL, Tailwind CSS, daisyUI, and a base layout).

## Requirements

- Elixir 1.17+ and Erlang/OTP (this repo was generated with Elixir 1.20)
- PostgreSQL 16+ running on `localhost:5432`
- A `postgres` role with password `postgres` (Phoenix defaults)

## Setup

```sh
mix setup
```

That installs Hex dependencies, creates and migrates the database, and builds assets.

If you only need the database:

```sh
mix ecto.create
```

Database names:

- Development: `opsdesk_dev`
- Test: `opsdesk_test`

Credentials live in `config/dev.exs` and `config/test.exs`. Change them if your local Postgres user differs.

## Run

```sh
mix phx.server
```

Or inside IEx:

```sh
iex -S mix phx.server
```

Then open [http://localhost:4000](http://localhost:4000).

You should see the OpsDesk header, Home nav, Register / Log in, theme toggle, and footer.

## Authentication

Accounts are generated with `mix phx.gen.auth`. In development, emails go to the Swoosh mailbox instead of a real SMTP server.

- Register: [http://localhost:4000/users/register](http://localhost:4000/users/register)
- Log in: [http://localhost:4000/users/log-in](http://localhost:4000/users/log-in)
- Dev mailbox: [http://localhost:4000/dev/mailbox](http://localhost:4000/dev/mailbox)

After registering, open the mailbox, open the confirmation/login email, and follow the link. Password changes and email changes live under Settings (`/users/settings`) and also send mail to the mailbox.

Protected LiveView routes use `pipe_through [:browser, :require_authenticated_user]` and `on_mount [{OpsDeskWeb.UserAuth, :require_authenticated}]`.


## Test

```sh
mix test
```

## Stack

- Phoenix 1.8 + LiveView
- PostgreSQL (Ecto + Postgrex)
- Tailwind CSS v4 + daisyUI
- Bandit
