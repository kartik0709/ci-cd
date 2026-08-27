// Fires whenever a row is inserted into heartbeat; logs it to system_event
table_trigger "heartbeat_insert" {
  table = "heartbeat"
  actions = {insert: true, update: false, delete: false, truncate: false}
  active = true
  description = "Logs a system_event row whenever a heartbeat is inserted"

  input {
    json new
    json old
    enum action {
      values = ["insert", "update", "delete", "truncate"]
    }

    text datasource
  }

  stack {
    db.add "system_event" {
      data = {
        source: "heartbeat_trigger",
        message: "heartbeat inserted: id=" ~ ($input.new|get:"id"|to_text)
      }
    }
  }

  history = 100
}
