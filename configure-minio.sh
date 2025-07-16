#!/bin/bash
# Aguardar MinIO estar pronto
kubectl wait --for=condition=ready pod -l app=minio -n data-stack --timeout=300s
# Configurar MinIO Client dentro do pod
kubectl exec -n data-stack deployment/minio -- mc alias set local http://localhost:9000 admin minio123
# Criar buckets necessários
kubectl exec -n data-stack deployment/minio -- mc mb local/lakehouse
kubectl exec -n data-stack deployment/minio -- mc mb local/airbyte
kubectl exec -n data-stack deployment/minio -- mc mb local/prefect
kubectl exec -n data-stack deployment/minio -- mc mb local/dbt
kubectl exec -n data-stack deployment/minio -- mc mb local/warehouse
# Configurar policies
kubectl exec -n data-stack deployment/minio -- mc policy set public local/lakehouse
kubectl exec -n data-stack deployment/minio -- mc policy set public local/warehouse
# Listar buckets criados
kubectl exec -n data-stack deployment/minio -- mc ls local/
echo "MinIO configurado com sucesso!"
