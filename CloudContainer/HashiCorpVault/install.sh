helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm search repo vault --versions
helm install vault hashicorp/vault \
    --set='server.ha.enabled=true' \
    --set='server.ha.raft.enabled=true'
kubectl get pods
kubectl exec vault-0 -- vault status
kubectl exec vault-0 -- vault operator init -key-shares=1 -key-threshold=1 -format=json > cluster-keys.json
VAULT_UNSEAL_KEY=$(cat cluster-keys.json | jq -r ".unseal_keys_b64[]")
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl get pods
cat cluster-keys.json | jq -r ".root_token"
CLUSTER_ROOT_TOKEN=$(cat cluster-keys.json | jq -r ".root_token")
kubectl exec vault-0 -- vault login $CLUSTER_ROOT_TOKEN
kubectl exec vault-0 -- vault operator raft list-peers
kubectl exec vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl exec vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
###
kubectl exec vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl exec vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY
##
kubectl exec vault-0 -- vault operator raft list-peers
kubectl get pods
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
#vault secrets enable -path=secret kv-v2
#vault kv put secret/devwebapp/config username='giraffe' password='salsa'
#vault kv get secret/devwebapp/config
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh
#vault auth enable kubernetes
#vault write auth/kubernetes/config kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
# vault policy write devwebapp - <<EOF
# path "secret/data/devwebapp/config" {
#   capabilities = ["read"]
# }
# EOF
# vault write auth/kubernetes/role/devweb-app \
#         bound_service_account_names=internal-app \
#         bound_service_account_namespaces=default \
#         policies=devwebapp \
#         ttl=24h
kubectl create sa internal-app
kubectl apply --filename devwebapp.yaml
kubectl get pods
kubectl exec --stdin=true --tty=true devwebapp -c devwebapp -- cat /vault/secrets/credentials.txt
