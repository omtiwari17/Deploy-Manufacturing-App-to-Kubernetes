# ─────────────────────────────────────────────
# Multi-Agent Manufacturing System
# DevOps Deployment Dockerfile
#
# Strategy: Clone the AI repo at build time.
# This DevOps repo stays pure — zero app code.
# ─────────────────────────────────────────────

FROM python:3.11-slim

LABEL maintainer="omtiwari17"
LABEL project="multi-agent-manufacturing"
LABEL version="1.0"

# ─────────────────────────────────────────────
# System dependencies
# ─────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# ─────────────────────────────────────────────
# Copy ONLY requirements.txt first
# (before clone so it doesn't get overwritten)
# ─────────────────────────────────────────────
WORKDIR /app
COPY requirements.txt /requirements.txt

# ─────────────────────────────────────────────
# Clone the AI repo into /app
# This fills /app with the Multi-agent-system code:
#   /app/frontend/app.py
#   /app/backend/agents.py  etc.
# ─────────────────────────────────────────────
RUN git clone https://github.com/omtiwari17/Multi-agent-system.git .

# ─────────────────────────────────────────────
# Now copy requirements.txt into /app
# Overrides the AI repo's pip-freeze version
# ─────────────────────────────────────────────
RUN cp /requirements.txt /app/requirements.txt

# ─────────────────────────────────────────────
# Install Python dependencies
# ─────────────────────────────────────────────
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# ─────────────────────────────────────────────
# Create artifacts directory
# ─────────────────────────────────────────────
RUN mkdir -p /app/artifacts

# ─────────────────────────────────────────────
# Disable CrewAI telemetry
# ─────────────────────────────────────────────
ENV CREWAI_TRACING_ENABLED=false
ENV CREWAI_TELEMETRY_ENABLED=false
ENV CREWAI_DISABLE_TELEMETRY=true
ENV OTEL_SDK_DISABLED=true

# ─────────────────────────────────────────────
# Streamlit server config
# ADDRESS 0.0.0.0 is critical for Kubernetes
# ─────────────────────────────────────────────
ENV STREAMLIT_SERVER_HEADLESS=true
ENV STREAMLIT_SERVER_PORT=8501
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0
ENV STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

# ─────────────────────────────────────────────
# Expose Streamlit port
# ─────────────────────────────────────────────
EXPOSE 8501

# ─────────────────────────────────────────────
# Health check
# K8s probes this to confirm pod is ready.
# New pod MUST pass this before old pod is killed
# — this is what enables zero-downtime rolling updates
# ─────────────────────────────────────────────
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

# ─────────────────────────────────────────────
# Start the Streamlit app
# ─────────────────────────────────────────────
CMD ["streamlit", "run", "frontend/app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]
