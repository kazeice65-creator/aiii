#!/usr/bin/env bash
set -e

export HERMES_HOME="${HERMES_HOME:-/data/.hermes}"
export HOME="${HOME:-/data}"

mkdir -p "$HERMES_HOME/cron" \
  "$HERMES_HOME/sessions" \
  "$HERMES_HOME/logs" \
  "$HERMES_HOME/memories" \
  "$HERMES_HOME/skills" \
  "$HERMES_HOME/pairing" \
  "$HERMES_HOME/hooks" \
  "$HERMES_HOME/image_cache" \
  "$HERMES_HOME/audio_cache" \
  "$HERMES_HOME/workspace" \
  "$HERMES_HOME/plans" \
  "$HERMES_HOME/home"

if [ -f /opt/hermes-agent/cli-config.yaml.example ] && [ ! -f "$HERMES_HOME/config.yaml" ]; then
  cp /opt/hermes-agent/cli-config.yaml.example "$HERMES_HOME/config.yaml"
fi

cat > "$HERMES_HOME/.env" <<EOF
API_SERVER_ENABLED=true
API_SERVER_HOST=0.0.0.0
API_SERVER_PORT=${PORT:-8642}
API_SERVER_KEY=${API_SERVER_KEY}
API_SERVER_MODEL_NAME=${API_SERVER_MODEL_NAME:-hermes-agent}

OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
LLM_MODEL=${LLM_MODEL}
EOF

rm -f "$HERMES_HOME/gateway.pid"

echo "Starting Hermes Agent API Server on port ${PORT:-8642}"
exec hermes gateway
