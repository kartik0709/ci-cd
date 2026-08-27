// List the journal entry lines posted to an account
query "accounts/{account_id}/ledger" verb=GET {
  api_group = "Bookkeeping"
  description = "List the journal entry lines posted to an account, most recently recorded first"
  auth = "user"

  input {
    int account_id {
      table = "account"
    }
    date start_date?
    date end_date?
    int page?=1 filters=min:1
    int per_page?=50 filters=min:1|max:200
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
      eval = {
        entry_date: $db.entry.date,
        entry_memo: $db.entry.memo,
        entry_reference: $db.entry.reference
      }
      sort = { id: "desc" }
      return = { type: "list", paging: { page: $input.page, per_page: $input.per_page, totals: true } }
    } as $ledger_page
  }

  response = { account: $account, ledger: $ledger_page }
}
