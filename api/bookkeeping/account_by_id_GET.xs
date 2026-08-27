// Get a single account with its current balance
query "accounts/{account_id}" verb=GET {
  api_group = "Bookkeeping"
  description = "Get a single account with its current balance"
  auth = "user"

  input {
    int account_id {
      table = "account"
    }
  }

  stack {
    db.get "account" {
      field_name = "id"
      field_value = $input.account_id
    } as $account

    precondition ($account != null) {
      error_type = "notfound"
      error = "Account not found"
    }

    function.run "account_balance" {
      input = { account_id: $input.account_id }
    } as $bal
  }

  response = $account|set:"balance":$bal.balance
}
