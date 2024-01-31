#!/bin/bash
sudo apt update && sudo apt install gpg
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vault
vault server -dev -dev-listen-address="0.0.0.0:8200" -d

# vault auth enable approle
# vault policy write terraform - <<EOF
# path "*" {
#     capabilities = ["list", "read"]
#     }

#     path "secrets/data/*" {
#     capabilities = ["create", "read", "update", "delete", "list"]
#     }

#     path "kv/data/*" {
#     capabilities = ["create", "read", "update", "delete", "list"]
#     }


#     path "secret/data/*" {
#     capabilities = ["create", "read", "update", "delete", "list"]
#     }

#     path "auth/token/create" {
#     capabilities = ["create", "read", "update", "list"]
#     }
# EOF

# vault write auth/approle/role/terraform \
#     secret_id_ttl=10m \
#     token_num_uses=10 \
#     token_ttl=20m \
#     token_max_ttl=30m \
#     secret_id_num_uses=40 \
#     token_policies=terraform

# vault read auth/approle/role/my-approle/role-id
# vault write -f auth/approle/role/my-approle/secret-id