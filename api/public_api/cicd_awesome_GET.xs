// Endpoint that returns a message about the CI/CD process
// Returns 'This CI/CD process with Github is awesome!'
query cicd_awesome verb=GET {
  api_group = "Public API"

  input {
  }

  stack {
  }

  response = "This CI/CD process with Github is awesome!"
}
