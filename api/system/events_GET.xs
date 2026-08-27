// List the most recent system_event rows written by the trigger and the async function
query "events" verb=GET {
  api_group = "System"
  description = "List the most recent system_event rows written by heartbeat_insert and ping_async"

  input {
    int per_page?=20 filters=min:1|max:100
  }

  stack {
    db.query "system_event" {
      sort = { created_at: "desc" }
      return = { type: "list", paging: { page: 1, per_page: $input.per_page, totals: true } }
    } as $events
  }

  response = $events
}
