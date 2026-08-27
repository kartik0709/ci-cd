// List chart-of-accounts, optionally filtered by type/status, with computed balances
query "accounts" verb=GET {
  api_group = "Bookkeeping"
  description = "List chart-of-accounts entries, optionally including each account's current balance"
  auth = "user"

  input {
    enum type? {
      values = ["asset", "liability", "equity", "income", "expense"]
    }
    bool is_active?
    bool with_balance?=true
    int page?=1 filters=min:1
    int per_page?=50 filters=min:1|max:200
  }

  stack {
    db.query "account" {
      where = $db.account.type ==? $input.type && $db.account.is_active ==? $input.is_active
      sort = { code: "asc" }
      return = { type: "list", paging: { page: $input.page, per_page: $input.per_page, totals: true } }
    } as $accounts_page

    conditional {
      if ($input.with_balance == true) {
        var $enriched { value = [] }

        foreach ($accounts_page.items) {
          each as $acct {
            function.run "account_balance" {
              input = { account_id: $acct.id }
            } as $bal

            array.push $enriched { value = $acct|set:"balance":$bal.balance }
          }
        }

        var.update $accounts_page { value = $accounts_page|set:"items":$enriched }
      }
    }
  }

  response = $accounts_page
}
