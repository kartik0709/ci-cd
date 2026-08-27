// Generic event log written by the heartbeat trigger and the async ping function
table "system_event" {
  auth = false

  schema {
    int id
    text source filters=trim
    text message filters=trim
    timestamp created_at?=now
  }

  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree", field: [{name: "created_at", op: "desc"}]}
  ]
}
