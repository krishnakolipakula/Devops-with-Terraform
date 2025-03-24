resource "vault_policy" "example" {
  name = "read-secrets"
  policy = <<EOF
path "secret/data/my_secrets/*" {
  capabilities = ["read"]
}
EOF
}

resource "vault_generic_secret" "my_secret" {
  path = "secret/data/my_secrets"
  data = {
    username = "my_user"
    password = "my_password"
  }
}

resource "vault_auth_method" "approle" {
  type = "approle"
}
