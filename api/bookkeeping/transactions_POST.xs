// Record a balanced journal entry (double-entry transaction) with two or more lines
query "transactions" verb=POST {
  api_group = "Bookkeeping"
  description = "Record a balanced journal entry (double-entry transaction) with two or more lines"

  input {
    date date
    text memo? filters=trim
    text reference? filters=trim
    object[] lines {
      schema {
        int account_id {
          table = "account"
        }
        decimal debit?=0 filters=min:0
        decimal credit?=0 filters=min:0
        text memo? filters=trim
      }
    }
  }

  stack {
    precondition (($input.lines|count) >= 2) {
      error_type = "inputerror"
      error = "A journal entry requires at least two lines"
    }

    var $total_debit { value = $input.lines|map:$$.debit|sum|round:2 }
    var $total_credit { value = $input.lines|map:$$.credit|sum|round:2 }

    precondition ($total_debit == $total_credit) {
      error_type = "inputerror"
      error = "Journal entry is not balanced: total debits must equal total credits"
    }

    precondition ($total_debit > 0) {
      error_type = "inputerror"
      error = "Journal entry must have a nonzero amount"
    }

    foreach ($input.lines) {
      each as $line {
        precondition (($line.debit > 0 && $line.credit == 0) || ($line.credit > 0 && $line.debit == 0)) {
          error_type = "inputerror"
          error = "Each line must be either a debit or a credit, not both or neither"
        }

        db.get "account" {
          field_name = "id"
          field_value = $line.account_id
        } as $line_account

        precondition ($line_account != null) {
          error_type = "notfound"
          error = "Account not found"
        }

        precondition ($line_account.is_active == true) {
          error_type = "inputerror"
          error = ("Account is not active: " ~ $line_account.name)
        }
      }
    }

    db.transaction {
      stack {
        db.add "journal_entry" {
          data = {
            date: $input.date,
            memo: $input.memo,
            reference: $input.reference
          }
        } as $entry

        foreach ($input.lines) {
          each as $line {
            db.add "journal_entry_line" {
              data = {
                journal_entry_id: $entry.id,
                account_id: $line.account_id,
                debit: $line.debit,
                credit: $line.credit,
                memo: $line.memo
              }
            }
          }
        }
      }
    }

    db.query "journal_entry_line" {
      where = $db.journal_entry_line.journal_entry_id == $entry.id
    } as $entry_lines
  }

  response = { entry: $entry, lines: $entry_lines }
}
