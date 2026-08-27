function "account_balance" {
  description = "Computes an account's balance (in its natural debit/credit direction), optionally scoped to a date range"

  input {
    int account_id {
      table = "account"
    }
    date start_date?
    date end_date?
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

    db.query "journal_entry_line" {
      join = {
        entry: {
          table: "journal_entry"
          where: $db.journal_entry_line.journal_entry_id == $db.entry.id
        }
      }
      where = $db.journal_entry_line.account_id == $input.account_id && $db.entry.date >=? $input.start_date && $db.entry.date <=? $input.end_date
    } as $lines

    var $debit_total { value = $lines|map:$$.debit|sum|round:2 }
    var $credit_total { value = $lines|map:$$.credit|sum|round:2 }
    var $balance { value = 0 }

    conditional {
      if ($account.type == "asset" || $account.type == "expense") {
        var.update $balance { value = $debit_total - $credit_total }
      }
      else {
        var.update $balance { value = $credit_total - $debit_total }
      }
    }
  }

  response = {
    account_id: $input.account_id,
    type: $account.type,
    debit_total: $debit_total,
    credit_total: $credit_total,
    balance: $balance
  }
}
