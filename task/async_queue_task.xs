// Every 30 seconds for 4 hours: invokes ping_async 30 times per tick.
// Note: this engine does not support true async/await (confirmed empirically
// while building heartbeat_task), so these 30 calls run sequentially each
// tick rather than concurrently.
// Every 30 seconds for 4 hours, runs ping_async 30 times per tick
task async_queue_task {
  stack {
    for (30) {
      each as $i {
        function.run ping_async as $result
      }
    }
  }

  schedule = [
    {
      starts_on: 2026-08-27 03:27:00+0000
      freq     : 30
      ends_on  : 2026-08-27 07:27:00+0000
    }
  ]

  guid = "21aRuJe6c5xhadbNcO2cNbyVclw"
}