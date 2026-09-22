// Fires whenever a row is inserted into heartbeat; logs it to system_event
// Logs a system_event row whenever a heartbeat is inserted
table_trigger heartbeat_insert {
  table = "heartbeat"

  input {
    json new
    json old
    enum action {
      values = ["insert", "update", "delete", "truncate"]
    }
  
    text datasource
  }

  stack {
    db.add system_event {
      data = {
        source : "heartbeat_trigger"
        message: "heartbeat inserted: id=" ~ ($input.new|get:"id"|to_text)
      }
    }
  }

  actions = {insert: true}
  history = 100
  guid = "b93Xg7eys6AyH3sfEzi0ks1DeWU"
}