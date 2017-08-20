defmodule RaiEx do
  require Logger
  import HTTPoison
  alias HTTPoison.Response
  use RPC

  @default_port "7076"
  @headers [{"Content-Type", "application/json"}]

  def connect(url \\ "http://localhost:7076") do
    :ets.new(:params, [:named_table])
    true = :ets.insert(:params, [{:url, parse_url(url)}])
    :ok
  end

  @doc """
  Returns how many RAW is owned and how many have not yet been received by `account`.
  """
  rpc :account_balance do
    param "account", :string
  end

  @doc """
  Gets the number of blocks for a specific `account`.
  """
  rpc :account_block_count do
    param "account", :string
  end

  @doc """
  Returns frontier, open block, change representative block, balance,
  last modified timestamp from local database & block count for `account`.
  """
  rpc :account_info do
    param "account", :string
  end

  @doc """
  Creates a new account, insert next deterministic key in `wallet`.
  """
  rpc :account_create do
    param "wallet", :string
  end

  @doc """
  Get account number for the `public key`.
  """
  rpc :account_get do
    param "key", :string
  end

  @doc """
  Reports send/receive information for an `account`.
  """
  rpc :account_history do
    param "account", :string
    param "count", :integer
  end

  @doc """
  Lists all the accounts inside `wallet`.
  """
  rpc :account_list do
    param "wallet", :string
  end

  @doc """
  Moves accounts from `source` to `wallet`.

  # Node must have 'enable_control' set to 'true'
  """
  rpc :account_move do
    param "wallet", :string
    param "source", :string
    param "accounts", :list
  end

  @doc """
  Get the `public key` for `account`.
  """
  rpc :account_key do
    param "account", :string
  end

  @doc """
  Remove `account` from `wallet`.
  """
  rpc :account_remove do
    param "wallet", :string
    param "account", :string
  end

  @doc """
  Returns the representative for `account`.
  """
  rpc :account_representative do
    param "account", :string
  end

  @doc """
  Sets the representative for `account` in `wallet`.

  # Node must have 'enable_control' set to 'true'
  """
  rpc :account_representative_set do
    param "wallet", :string
    param "account", :string
    param "representative", :string
  end

  @doc """
  Returns the voting weight for `account`.
  """
  rpc :account_weight do
    param "account", :string
  end

  @doc """
  Returns how many RAW is owned and how many have not yet been received by accounts list.
  """
  rpc :accounts_balances do
    param "accounts", :list
  end

  @doc """
  Returns a list of pairs of account and block hash representing the head block for `accounts`.
  """
  rpc :accounts_frontiers do
    param "accounts", :list
  end

  @doc """
  Returns a list of block hashes which have not yet been received by these `accounts`.

  # Optional `threshold`, only returns hashes with amounts >= threshold.
  """
  rpc :accounts_pending do
    param "accounts", :list
    param "count", :integer
  end

  rpc :accounts_pending do
    param "accounts", :list
    param "count", :integer
    param "threshold", :number
  end

  @doc """
  Returns how many rai are in the public supply.
  """
  rpc :available_supply do
  end

  @doc """
  Retrieves a json representation of `block`.
  """
  rpc :block do
    param "hash", :string
  end

  @doc """
  Retrieves a json representations of multiple `blocks`.
  """
  rpc :blocks do
    param "hashes", :list
  end

  @doc """
  Retrieves a json representations of `blocks` with transaction `amount` & block `account`.
  """
  rpc :blocks_info do
    param "hashes", :list
  end

  @doc """
  Returns the `account` containing the `block`.
  """
  rpc :block_account do
    param "hash", :string
  end

  @doc """
  Reports the number of blocks in the ledger and unchecked synchronizing blocks.
  """
  rpc :block_count do
  end

  @doc """
  Reports the number of blocks in the ledger by type (send, receive, open, change).
  """
  rpc :block_count_type do
  end

  @doc """
  Initialize bootstrap to specific IP address and `port`.
  """
  rpc :bootstrap do
    param "address", :string
    param "port", :integer
  end

  @doc """
  Initialize multi-connection bootstrap to random peers.
  """
  rpc :bootstrap_any do
  end

  @doc """
  Returns a list of block hashes in the account chain starting at `block` up to `count`.
  """
  rpc :chain do
    param "block", :string
    param "count", :integer
  end

  @doc """
  Returns a list of pairs of delegator names given `account` a representative and its balance.
  """
  rpc :delegators do
    param "account", :string
  end

  @doc """
  Get number of delegators for a specific representative `account`.
  """
  rpc :delegators_count do
    param "account", :string
  end

  @doc """
  Derive deterministic keypair from `seed` based on `index`.
  """
  rpc :deterministic_key do
    param "seed", :string
    param "index", :integer
  end

  @doc """
  Returns a list of pairs of account and block hash representing the head block starting at account up to count.
  """
  rpc :frontiers do
    param "account", :string
    param "count", :integer
  end

  @doc """
  Reports the number of accounts in the ledger.
  """
  rpc :frontier_count do
  end

  @doc """
  Reports send/receive information for a chain of blocks.
  """
  rpc :history do
    param "hash", :string
    param "count", :integer
  end

  @doc """
  Divide a raw amount down by the Mrai ratio.
  """
  rpc :mrai_from_raw do
    param "amount", :number
  end

  @doc """
  Multiply an Mrai amount by the Mrai ratio.
  """
  rpc :mrai_to_raw do
    param "amount", :number
  end

  @doc """
  Divide a raw amount down by the krai ratio.
  """
  rpc :krai_from_raw do
    param "amount", :number
  end

  @doc """
  Multiply an krai amount by the krai ratio.
  """
  rpc :krai_to_raw do
    param "amount", :number
  end

  @doc """
  Divide a raw amount down by the rai ratio.
  """
  rpc :rai_from_raw do
    param "amount", :number
  end

  @doc """
  Multiply an rai amount by the rai ratio.
  """
  rpc :rai_to_raw do
    param "amount", :number
  end

  @doc """
  Tells the node to send a keepalive packet to address:port.
  """
  rpc :keepalive do
    param "address", :string
    param "port", :integer
  end

  @doc """
  Generates an `adhoc random keypair`
  """
  rpc :key_create do
  end

  @doc """
  Derive public key and account number from `private key`.
  """
  rpc :key_expand do
    param "key", :string
  end

  @doc """
  Begin a new payment session. Searches wallet for an account that's
  marked as available and has a 0 balance. If one is found, the account
  number is returned and is marked as unavailable. If no account is found,
  a new account is created, placed in the wallet, and returned.
  """
  rpc :payment_begin do
    param "wallet", :string
  end

  @doc """
  Marks all accounts in wallet as available for being used as a payment session.
  """
  rpc :payment_init do
    param "wallet", :string
  end

  @doc """
  End a payment session. Marks the account as available for use in a payment session. 
  """
  rpc :payment_end do
    param "account", :string
    param "wallet", :string
  end

  @doc """
  Wait for payment of 'amount' to arrive in 'account' or until 'timeout' milliseconds have elapsed.
  """
  rpc :payment_wait do
    param "account", :string
    param "amount", :number
    param "timeout", :number
  end

  @doc """
  Publish `block` to the network.
  """
  rpc :process do
    param "block", :string
  end

  @doc """
  Receive pending block for account in wallet

  ## enable_control must be set to true
  """
  rpc :receive do
    param "wallet", :string
    param "account", :string
    param "block", :string
  end

  @doc """
  Returns receive minimum for node.

  ## enable_control must be set to true
  """
  rpc :receive_minimum do
  end

  @doc """
  Set `amount` as new receive minimum for node until restart
  """
  rpc :receive_minimum_set do
    param "amount", :number
  end

  @doc """
  Returns a list of pairs of representative and its voting weight.
  """
  rpc :representatives do
  end

  @doc """
  Returns the default representative for `wallet`.
  """
  rpc :wallet_representative do
    param "wallet", :string
  end

  @doc """
  Sets the default representative for wallet.

  ## enable_control must be set to true
  """
  rpc :wallet_representative_set do
    param "wallet", :string
    param "representative", :string
  end

  @doc """
  Rebroadcast blocks starting at `hash` to the network.
  """
  rpc :republish do
    param "hash", :string
  end

  @doc """
  Additionally rebroadcast source chain blocks for receive/open up to `sources` depth.
  """
  rpc :republish do
    param "hash", :string
    param "sources", :integer
  end

  @doc """
  Tells the node to look for pending blocks for any account in `wallet`.
  """
  rpc :search_pending do
    param "wallet", :string
  end

  @doc """
  Tells the node to look for pending blocks for any account in all available wallets.
  """
  rpc :seach_pending_all do
  end

  @doc """
  Send `amount` from `source` in `wallet` to destination
  """
  rpc :send do
    param "wallet", :string
    param "source", :string
    param "destination", :string
    param "amount", :number
  end

  @doc """
  # enable_control must be set to true
  """
  rpc :stop do
  end

  @doc """
  Check whether account is a valid account number.
  """
  rpc :validate_account_number do
    param "account", :string
  end

  @doc """
  Returns a list of block hashes in the account chain ending at block up to count.
  """
  rpc :successors do
    param "block", :string
    param "count", :number
  end

  @doc """
  Retrieves node versions.
  """
  rpc :version do
  end

  @doc """
  Returns a list of pairs of peer IPv6:port and its node network version.
  """
  rpc :peers do
  end

  @doc """
  Returns a list of block hashes which have not yet been received by this account.
  """
  rpc :pending do
    param "account", :string
    param "count", :integer
  end

  @doc """
  Returns a list of pending block hashes with amount more or equal to threshold.
  """
  rpc :pending do
    param "account", :string
    param "count", :integer
    param "threshold", :number
  end

  @doc """
  Check whether block is pending by hash.
  """
  rpc :pending_exists do
    param "hash", :string
  end

  @doc """
  Returns a list of pairs of unchecked synchronizing block hash and its json representation up to count.
  """
  rpc :unchecked do
    param "count", :integer
  end

  @doc """
  Clear unchecked synchronizing blocks.

  ## enable_control must be set to true
  """
  rpc :unchecked_clear do
  end

  @doc """
  Retrieves a json representation of unchecked synchronizing block by hash.
  """
  rpc :unchecked_get do
    param "hash", :string
  end

  @doc """
  Retrieves unchecked database keys, blocks hashes & a json representations of unchecked pending blocks starting from key up to count.
  """
  rpc :unchecked_keys do
    param "key", :string
    param "count", :integer
  end

  @doc """
  Add an adhoc private key key to wallet.

  ## enable_control must be set to true
  """
  rpc :wallet_add do
    param "wallet", :string
    param "key", :string
  end

  @doc """
  Returns the sum of all accounts balances in wallet.
  """
  rpc :wallet_balance_total do
    param "wallet", :string
  end

  @doc """
  Returns how many rai is owned and how many have not yet been received by all accounts in .
  """
  rpc :wallet_balances do
    param "wallet", :string
  end

  @doc """
  Changes seed for wallet to seed.

  ## enable_control must be set to true  
  """
  rpc :wallet_change_seed do
    param "wallet", :string
    param "seed", :string
  end

  @doc """
  Check whether wallet contains account.
  """
  rpc :wallet_contains do
    param "wallet", :string
    param "account", :string
  end

  @doc """
  Creates a new random wallet id.

  ## enable_control must be set to true
  """
  rpc :wallet_create do
  end

  @doc """
  Destroys wallet and all contained accounts.

  ## enable_control must be set to true
  """
  rpc :wallet_destroy do
    param "wallet", :string
  end

  @doc """
  Return a json representation of wallet.
  """
  rpc :wallet_export do
    param "wallet", :string
  end

  @doc """
  Returns a list of pairs of account and block hash representing the head block starting
  for accounts from wallet.
  """
  rpc :wallet_frontiers do
    param "wallet", :string
  end

  @doc """
  Returns a list of block hashes which have not yet been received by accounts in this wallet.
  
  ## enable_control must be set to true
  """
  rpc :wallet_pending do
    param "wallet", :string
    param "count", :integer
  end

  @doc """
  Returns a list of pending block hashes with amount more or equal to threshold.
  
  ## enable_control must be set to true
  """
  rpc :wallet_pending do
    param "wallet", :string
    param "count", :integer
    param "threshold", :number
  end

  @doc """
  Rebroadcast blocks for accounts from wallet starting at frontier down to count to the network.
  
  ## enable_control must be set to true
  """
  rpc :wallet_republish do
    param "wallet", :string
    param "count", :integer
  end

  @doc """
  Returns a list of pairs of account and work from wallet.
  
  ## enable_control must be set to true
  """
  rpc :wallet_work_get do
    param "wallet", :string
  end

  @doc """
  Changes the password for wallet to password.

  ## enable_control must be set to true
  """
  rpc :password_change do
    param "wallet", :string
    param "password", :string
  end

  @doc """
  Enters the password in to wallet.
  """
  rpc :password_enter do
    param "wallet", :string
    param "password", :string
  end

  @doc """
  Checks whether the password entered for wallet is valid.
  """
  rpc :password_valid do
    param "wallet", :string
    param "wallet", :string
  end

  @doc """
  Stop generating work for block.

  ## enable_control must be set to true
  """
  rpc :work_cancel do
    param "hash", :string
  end

  @doc """
  Generates work for block

  ## enable_control must be set to true
  """
  rpc :work_generate do
    param "hash", :string
  end

  @doc """
  Retrieves work for account in wallet.

  ## enable_control must be set to true
  """
  rpc :work_get do
    param "wallet", :string
    param "account", :string
  end

  @doc """
  Set work for account in wallet.

  ## enable_control must be set to true
  """
  rpc :work_set do
    param "wallet", :string
    param "account", :string
    param "work", :string
  end

  @doc """
  Add specific IP address and port as work peer for node until restart.

  ## enable_control must be set to true
  """
  rpc :work_peer_add do
    param "address", :string
    param "port", :integer
  end

  @doc """
  Retrieves work peers.

  ## enable_control must be set to true
  """
  rpc :work_peers do
  end

  @doc """
  Clear work peers node list until restart.

  ## enable_control must be set to true
  """
  rpc :work_peers_clear do
  end

  @doc """
  Check whether work is valid for block.
  """
  rpc :work_validate do
    param "work", :string
    param "hash", :string
  end

  # @doc """
  # Send JSON POST requests with every new block to
  # callback server http://callback_address:callback_port<callback_target>
  # defined in config.json.
  # """
  # # NOT SURE


  defp parse_url(url) do
    case String.splitter(url, ["://", ":"]) |> Enum.take(3) do
      ["http", "localhost", port] -> "http://" <> "127.0.0.1" <> ":" <> port
      ["http", host, port] -> "http://" <> host <> ":" <> port
      ["http", host] -> "http://" <> host <> ":" <> @default_port
      [host, port] -> "http://" <> host <> ":" <> port
      [host] -> "http://" <> host <> ":" <> @default_port
    end
  end

  defp get_url do
    [{:url, url}] = :ets.lookup(:params, :url)
    url
  end

  # Posts the message to the node and decodes the response
  defp post_json_rpc(json) do
    with {:ok, %Response{status_code: 200, body: body}} <- post(get_url(), json, @headers),
         {:ok, map} <- Poison.decode(body)
         do
           {:ok, map}
         else
           {:error, val} -> {:error, val}
         end
  end
end
