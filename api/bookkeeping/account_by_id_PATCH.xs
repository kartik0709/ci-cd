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
    bool is_active?
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

    var $name_provided { value = ($input.name ?? "__UNSET__") != "__UNSET__" }
    conditional {
      if ($name_provided == true) {
        var.update $updates { value = $updates|set:"name":$input.name }
      }
    }
    var $description_provided { value = ($input.description ?? "__UNSET__") != "__UNSET__" }
    conditional {
      if ($description_provided == true) {
        var.update $updates { value = $updates|set:"description":$input.description }
      }
    }
    var $is_active_provided { value = ($input.is_active ?? "__UNSET__") != "__UNSET__" }
    conditional {
      if ($is_active_provided == true) {
        var.update $updates { value = $updates|set:"is_active":$input.is_active }
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
