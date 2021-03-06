![RaiEx](https://raw.githubusercontent.com/willHol/rai_ex/master/logo-wide.png)

[![Build Status](https://travis-ci.org/willHol/rai_ex.svg?branch=master)](https://travis-ci.org/willHol/rai_ex)
[![Hex.pm](https://img.shields.io/hexpm/v/rai_ex.svg)](https://hex.pm/packages/rai_ex)
[![Inline docs](http://inch-ci.org/github/willHol/rai_ex.svg)](http://inch-ci.org/github/willHol/rai_ex)

RaiEx is an *Elixir client* for managing a **RaiBlocks** node, here is an example:

```elixir
alias RaiEx.{Block, Tools}

account = "xrb_3t6k35gi95xu6tergt6p69ck76ogmitsa8mnijtpxm9fkcm736xtoncuohr3"

# RPC mappings
{:ok, %{"balance" => balance, "frontier" => frontier}} = RaiEx.account_info(account)
{:ok, %{"key" => key}} = RaiEx.account_key(account)

# Derive the first account from the wallet seed
{priv, pub} = Tools.seed_account!("9F1D53E732E48F25F94711D5B22086778278624F715D9B2BEC8FB81134E7C904", 0)

# Derives an "xrb_" address
address = Tools.create_account!(pub)

# Get the previous block hash
{:ok, %{"frontier" => block_hash}} = RaiEx.account_info(address)

block = %Block{
  previous: block_hash,
  destination: "xrb_1aewtdjz8knar65gmu6xo5tmp7ijrur1fgtetua3mxqujh5z9m1r77fsrpqw",
  balance: 0
}

# Signs and broadcasts the block to the network
block |> Block.sign(priv, pub) |> Block.send()

```

To get started read the [online documentation](https://hexdocs.pm/rai_ex/).

## Installation

Add the following to your `mix.exs`:

```elixir
def deps do
  [
    {:rai_ex, "~> 0.3.0"}
  ]
end
```
