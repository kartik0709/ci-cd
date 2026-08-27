// Summary totals by account type, net income, cash position, and recent activity
query "dashboard" verb=GET {
  api_group = "Bookkeeping"
  description = "Summary totals by account type, net income, cash position, and recent activity"
  auth = "user"

  input {
    date start_date?
    date end_date?
  }

  stack {
    db.query "account" {
      where = $db.account.is_active == true
    } as $accounts

    var $totals { value = { asset: 0, liability: 0, equity: 0, income: 0, expense: 0 } }

    foreach ($accounts) {
      each as $acct {
        function.run "account_balance" {
          input = {
            account_id: $acct.id,
            start_date: $input.start_date,
            end_date: $input.end_date
          }
        } as $bal

        var.update $totals {
          value = $totals|set:$acct.type:(($totals|get:$acct.type) + $bal.balance)
        }
      }
    }

    var $net_income { value = $totals.income - $totals.expense }
    var $cash_position { value = $totals.asset - $totals.liability }

    db.query "journal_entry" {
      sort = { date: "desc" }
      return = { type: "list", paging: { page: 1, per_page: 10 } }
    } as $recent_entries
  }

  response = {
    totals: $totals,
    net_income: $net_income,
    cash_position: $cash_position,
    recent_transactions: $recent_entries
  }
}
