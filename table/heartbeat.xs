// Rows inserted by the recurring heartbeat_task, one per scheduled run
table "heartbeat" {
  auth = false

  schema {
    int id
    text note? filters=trim
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}
