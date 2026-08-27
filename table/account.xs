// Chart of accounts for the bookkeeping dashboard
table "account" {
  auth = false

  schema {
    int id
    text code filters=trim|upper
    text name filters=trim
    enum type {
      values = ["asset", "liability", "equity", "income", "expense"]
      description = "Determines which side (debit/credit) is the account's normal balance"
    }
    text description? filters=trim
    bool is_active?=true
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "code"}]}
    {type: "btree", field: [{name: "type"}]}
    {type: "btree", field: [{name: "is_active"}]}
  ]
}
