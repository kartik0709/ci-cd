// Journal entry (transaction) header
table journal_entry {
  auth = false

  schema {
    int id
    date date
    text memo? filters=trim
    text reference? filters=trim
  
    // User who recorded the entry
    int created_by? {
      table = "user"
    }
  
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "date", op: "desc"}]}
  ]

  guid = "YWHmPcQLL34P5VDX8d6MyqLsu0c"
}