// Get a single journal entry with its lines
query "transactions/{transaction_id}" verb=GET {
  api_group = "Bookkeeping"
  description = "Get a single journal entry with its lines"

  input {
    int transaction_id {
      table = "journal_entry"
    }
  }

  stack {
    db.get "journal_entry" {
      field_name = "id"
      field_value = $input.transaction_id
    } as $entry

    precondition ($entry != null) {
      error_type = "notfound"
      error = "Transaction not found"
    }

    db.query "journal_entry_line" {
      where = $db.journal_entry_line.journal_entry_id == $input.transaction_id
    } as $lines
  }

  response = { entry: $entry, lines: $lines }
}
