// Individual debit/credit split belonging to a journal entry
table "journal_entry_line" {
  auth = false

  schema {
    int id
    int journal_entry_id {
      table = "journal_entry"
    }
    int account_id {
      table = "account"
    }
    decimal debit?=0 filters=min:0
    decimal credit?=0 filters=min:0
    text memo? filters=trim
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "journal_entry_id"}]}
    {type: "btree", field: [{name: "account_id"}]}
  ]
}
