// Delete a journal entry and its lines
query "transactions/{transaction_id}" verb=DELETE {
  api_group = "Bookkeeping"
  description = "Delete a journal entry and its lines"

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

    db.transaction {
      stack {
        db.bulk.delete "journal_entry_line" {
          where = $db.journal_entry_line.journal_entry_id == $input.transaction_id
        }

        db.del "journal_entry" {
          field_name = "id"
          field_value = $input.transaction_id
        }
      }
    }
  }

  response = { success: true }
}
