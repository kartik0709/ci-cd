// Income and expense totals for a date range, with net income
query "reports/profit-loss" verb=GET {
  api_group = "Bookkeeping"
  description = "Income and expense totals for a date range, with net income"

  input {
    date start_date?="1970-01-01"
    date end_date?="2999-12-31"
  }

  stack {
    db.query "account" {
      where = $db.account.type == "income" && $db.account.is_active == true
      sort = { code: "asc" }
    } as $income_accounts

    db.query "account" {
      where = $db.account.type == "expense" && $db.account.is_active == true
      sort = { code: "asc" }
    } as $expense_accounts

    var $income_lines { value = [] }
    var $total_income { value = 0 }

    foreach ($income_accounts) {
      each as $acct {
        function.run "account_balance" {
          input = { account_id: $acct.id, start_date: $input.start_date, end_date: $input.end_date }
        } as $bal

        array.push $income_lines { value = { account: $acct, balance: $bal.balance } }
        math.add $total_income { value = $bal.balance }
      }
    }

    var $expense_lines { value = [] }
    var $total_expense { value = 0 }

    foreach ($expense_accounts) {
      each as $acct {
        function.run "account_balance" {
          input = { account_id: $acct.id, start_date: $input.start_date, end_date: $input.end_date }
        } as $bal

        array.push $expense_lines { value = { account: $acct, balance: $bal.balance } }
        math.add $total_expense { value = $bal.balance }
      }
    }

    var $net_income { value = $total_income - $total_expense }
  }

  response = {
    start_date: $input.start_date,
    end_date: $input.end_date,
    income: $income_lines,
    total_income: $total_income,
    expenses: $expense_lines,
    total_expense: $total_expense,
    net_income: $net_income
  }
}
