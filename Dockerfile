FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

ARG HERMES_REF=v2026.5.16

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates git tini && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch ${HERMES_REF} https://github.com/NousResearch/hermes-agent.git /opt/hermes-agent && \
    cd /opt/hermes-agent && \
    uv pip install --system --no-cache -e ".[all,messaging,tts-premium,honcho,bedrock,anthropic,edge-tts,hindsight]" && \
    rm -rf /opt/hermes-agent/.git

ENV HOME=/data
ENV HERMES_HOME=/data/.hermes

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/start.sh"]
