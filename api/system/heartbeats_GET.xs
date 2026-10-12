// List the most recent heartbeat rows inserted by heartbeat_task
// List the most recent heartbeat rows inserted by heartbeat_task
query heartbeats verb=GET {
  api_group = "System"

  input {
    int per_page?=20 filters=min:1|max:100
  }

  stack {
    db.query heartbeat {
      sort = {created_at: "desc"}
      return = {
        type  : "list"
        paging: {page: 1, per_page: $input.per_page, totals: true}
      }
    } as $heartbeats
  }

  response = $heartbeats
  guid = "ba3x7szN5BWAS3ANzNilx354ggw"
}