// Create a new chart-of-accounts entry
query "accounts" verb=POST {
  api_group = "Bookkeeping"
  description = "Create a new chart-of-accounts entry"

  input {
    text code filters=trim|upper
    text name filters=trim
    enum type {
      values = ["asset", "liability", "equity", "income", "expense"]
    }
    text description? filters=trim
    bool is_active?=true
  }

  stack {
    db.has "account" {
      field_name = "code"
      field_value = $input.code
    } as $code_exists

    precondition (!$code_exists) {
      error_type = "inputerror"
      error = "An account with this code already exists"
    }

    db.add "account" {
      data = {
        code: $input.code,
        name: $input.name,
        type: $input.type,
        description: $input.description,
        is_active: $input.is_active
      }
    } as $account
  }

  response = $account
}
