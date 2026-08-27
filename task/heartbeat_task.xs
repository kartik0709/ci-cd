// Every 30 seconds: insert a heartbeat (fires heartbeat_insert trigger) and run the async ping function
task "heartbeat_task" {
  description = "Every 30 seconds, inserts a heartbeat row (firing the heartbeat_insert trigger) and runs the async ping_async function"

  stack {
    db.add "heartbeat" {
      data = {
        note: "scheduled heartbeat"
      }
    } as $hb

    function.run "ping_async" {
      input = {}
    } as $ping_result
  }

  schedule = [{starts_on: 2026-08-26 00:00:00+0000, freq: 30}]
}
