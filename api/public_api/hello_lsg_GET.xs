// Endpoint that returns a welcome message for LSG
// Returns 'hey LSG! Welcome to Xano'
query hello_lsg verb=GET {
  api_group = "Public API"

  input {
  }

  stack {
  }

  response = "hey LSG! Welcome to Xano"
}
