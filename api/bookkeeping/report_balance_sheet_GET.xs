// Asset, liability, and equity balances as of a given date
query "reports/balance-sheet" verb=GET {
  api_group = "Bookkeeping"
  description = "Asset, liability, and equity balances as of a given date"

  input {
    date as_of?
  }

  stack {
    db.query "account" {
      where = $db.account.type == "asset" && $db.account.is_active == true
      sort = { code: "asc" }
    } as $asset_accounts

    db.query "account" {
      where = $db.account.type == "liability" && $db.account.is_active == true
      sort = { code: "asc" }
    } as $liability_accounts

    db.query "account" {
      where = $db.account.type == "equity" && $db.account.is_active == true
      sort = { code: "asc" }
    } as $equity_accounts

    var $assets { value = [] }
    var $total_assets { value = 0 }

    foreach ($asset_accounts) {
      each as $acct {
        function.run "account_balance" {
          input = { account_id: $acct.id, end_date: $input.as_of }
        } as $bal

        array.push $assets { value = { account: $acct, balance: $bal.balance } }
        math.add $total_assets { value = $bal.balance }
      }
    }

    var $liabilities { value = [] }
    var $total_liabilities { value = 0 }

    foreach ($liability_accounts) {
      each as $acct {
        function.run "account_balance" {
          input = { account_id: $acct.id, end_date: $input.as_of }
        } as $bal

        array.push $liabilities { value = { account: $acct, balance: $bal.balance } }
        math.add $total_liabilities { value = $bal.balance }
      }
    }

    var $equity { value = [] }
    var $total_equity { value = 0 }

    foreach ($equity_accounts) {
      each as $acct {
        function.run "account_balance" {
          input = { account_id: $acct.id, end_date: $input.as_of }
        } as $bal

        array.push $equity { value = { account: $acct, balance: $bal.balance } }
        math.add $total_equity { value = $bal.balance }
      }
    }
  }

  response = {
    as_of: $input.as_of,
    assets: $assets,
    total_assets: $total_assets,
    liabilities: $liabilities,
    total_liabilities: $total_liabilities,
    equity: $equity,
    total_equity: $total_equity,
    total_liabilities_and_equity: ($total_liabilities + $total_equity)
  }
}
