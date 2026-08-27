// Journal entry (transaction) header
table "journal_entry" {
  auth = false

  schema {
    int id
    date date
    text memo? filters=trim
    text reference? filters=trim
    int created_by? {
      table = "user"
      description = "User who recorded the entry"
    }
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "date", op: "desc"}]}
  ]
}
