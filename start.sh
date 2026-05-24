#!/usr/bin/env bash
set -e

export HERMES_HOME="${HERMES_HOME:-/data/.hermes}"
export HOME="${HOME:-/data}"

mkdir -p "$HERMES_HOME"

echo "Creating Hermes env..."

cat > "$HERMES_HOME/.env" <<EOF
API_SERVER_ENABLED=true
API_SERVER_HOST=0.0.0.0
API_SERVER_PORT=${PORT:-8080}
API_SERVER_KEY=${API_SERVER_KEY}

GATEWAY_ALLOW_ALL_USERS=true

OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
EOF

echo "Creating Hermes config..."

cat > "$HERMES_HOME/config.yaml" <<EOF
model:
  provider: openrouter
  default: ${HERMES_MODEL:-openai/gpt-4o-mini}
EOF

echo "Hermes env:"
cat "$HERMES_HOME/.env"

echo "Hermes config:"
cat "$HERMES_HOME/config.yaml"

rm -f "$HERMES_HOME/gateway.pid"

echo "Starting Hermes Agent API Server on port ${PORT:-8080}"

exec hermes gateway
