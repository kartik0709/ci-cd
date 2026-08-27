// Delete an account that has no journal entry lines posted against it
query "accounts/{account_id}" verb=DELETE {
  api_group = "Bookkeeping"
  description = "Delete an account that has no journal entry lines posted against it"
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

    db.has "journal_entry_line" {
      field_name = "account_id"
      field_value = $input.account_id
    } as $has_lines

    precondition (!$has_lines) {
      error_type = "inputerror"
      error = "Cannot delete an account that has journal entries; deactivate it instead"
    }

    db.del "account" {
      field_name = "id"
      field_value = $input.account_id
    }
  }

  response = { success: true }
}
