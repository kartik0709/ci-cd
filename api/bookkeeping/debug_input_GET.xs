// TEMP diagnostic endpoint - remove once the PATCH presence-detection bug is understood and fixed
query "debug/input" verb=GET {
  api_group = "Bookkeeping"
  description = "TEMP: introspects how omitted vs explicit optional inputs are represented"

  input {
    text name? filters=trim
    bool is_active?
  }

  stack {
    var $name_is_null { value = $input.name == null }
    var $name_coalesce { value = $input.name ?? "WAS_NULL" }
    var $is_active_is_null { value = $input.is_active == null }
    var $is_active_coalesce { value = $input.is_active ?? "WAS_NULL" }
  }

  response = {
    raw_name: $input.name,
    name_is_null: $name_is_null,
    name_coalesce: $name_coalesce,
    raw_is_active: $input.is_active,
    is_active_is_null: $is_active_is_null,
    is_active_coalesce: $is_active_coalesce
  }
}
