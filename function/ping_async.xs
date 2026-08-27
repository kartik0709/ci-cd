// Called by heartbeat_task on its own schedule tick (independent of any HTTP request):
// pings the public hello endpoint and logs the outcome. Note: this workspace's
// XanoScript engine does not accept the documented async/await api.request pattern
// (validated empirically), so this call is synchronous.
function "ping_async" {
  description = "Pings the public hello endpoint and logs the outcome"

  input {
  }

  stack {
    api.request {
      url = "https://xhqc-feze-bomo.dev.xano.io/api:public-api/hello"
      method = "GET"
    } as $ping_response

    db.add "system_event" {
      data = {
        source: "ping_async",
        message: "ping status=" ~ ($ping_response.response.status|to_text)
      }
    } as $logged
  }

  response = $ping_response
}
