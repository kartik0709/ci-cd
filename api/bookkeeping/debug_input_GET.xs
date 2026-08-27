// TEMP diagnostic endpoint - remove once the PATCH presence-detection bug is understood and fixed
query "debug/input" verb=GET {
  api_group = "Bookkeeping"
  description = "TEMP: introspects how omitted vs explicit optional inputs are represented"

  input {
    text name? filters=trim
    bool is_active?
    bool? is_active_n?
    text is_active_s? filters=trim
  }

  stack {
    var $name_is_null { value = $input.name == null }
    var $name_coalesce { value = $input.name ?? "WAS_NULL" }
    var $is_active_is_null { value = $input.is_active == null }
    var $is_active_coalesce { value = $input.is_active ?? "WAS_NULL" }
    var $is_active_n_is_null { value = $input.is_active_n == null }
    var $is_active_n_coalesce { value = $input.is_active_n ?? "WAS_NULL" }
    var $is_active_s_is_null { value = $input.is_active_s == null }
  }

  response = {
    raw_name: $input.name,
    name_is_null: $name_is_null,
    name_coalesce: $name_coalesce,
    raw_is_active: $input.is_active,
    is_active_is_null: $is_active_is_null,
    is_active_coalesce: $is_active_coalesce,
    raw_is_active_n: $input.is_active_n,
    is_active_n_is_null: $is_active_n_is_null,
    is_active_n_coalesce: $is_active_n_coalesce,
    raw_is_active_s: $input.is_active_s,
    is_active_s_is_null: $is_active_s_is_null
  }
}
