// Update an account's name, description, or active status
query "accounts/{account_id}" verb=PATCH {
  api_group = "Bookkeeping"
  description = "Update an account's name, description, or active status (code and type are immutable once created)"

  input {
    int account_id {
      table = "account"
    }
    text name? filters=trim
    text description? filters=trim
    text is_active? filters=trim {
      description = "Pass the string \"true\" or \"false\". A native JSON boolean is not usable here: this platform's XanoScript engine cannot distinguish an explicit false from an omitted field for boolean inputs (confirmed empirically), so the value is accepted as text instead."
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

    var $updates { value = {} }

    conditional {
      if ($input.name != null) {
        var.update $updates { value = $updates|set:"name":$input.name }
      }
    }
    conditional {
      if ($input.description != null) {
        var.update $updates { value = $updates|set:"description":$input.description }
      }
    }
    conditional {
      if ($input.is_active != null) {
        precondition ($input.is_active == "true" || $input.is_active == "false") {
          error_type = "inputerror"
          error = "is_active must be the string \"true\" or \"false\""
        }
        var.update $updates { value = $updates|set:"is_active":($input.is_active == "true") }
      }
    }

    precondition (($updates|is_empty) == false) {
      error_type = "inputerror"
      error = "No updates provided"
    }

    db.patch "account" {
      field_name = "id"
      field_value = $input.account_id
      data = $updates
    } as $updated_account
  }

  response = $updated_account
}
