# Base slim Python image
FROM python:3.11-slim

LABEL maintainer="omtiwari17"
LABEL project="multi-agent-manufacturing"
LABEL version="1.0"
# OS build tools and git for clone
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Stage requirements separately for layer cache
WORKDIR /app
COPY requirements.txt /requirements.txt

# Pull application source
RUN git clone https://github.com/omtiwari17/Multi-agent-system.git .

# Override repo-pinned requirements with DevOps version
RUN cp /requirements.txt /app/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Where job outputs land
RUN mkdir -p /app/artifacts

# Disable telemetry in images
ENV CREWAI_TRACING_ENABLED=false
ENV CREWAI_TELEMETRY_ENABLED=false
ENV CREWAI_DISABLE_TELEMETRY=true
ENV OTEL_SDK_DISABLED=true

# Streamlit service config
ENV STREAMLIT_SERVER_HEADLESS=true
ENV STREAMLIT_SERVER_PORT=8501
ENV STREAMLIT_SERVER_ADDRESS=0.0.0.0
ENV STREAMLIT_BROWSER_GATHER_USAGE_STATS=false

# Streamlit port
EXPOSE 8501

# Liveness for Streamlit endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8501/_stcore/health || exit 1

# Launch app
CMD ["streamlit", "run", "frontend/app.py", \
     "--server.port=8501", \
     "--server.address=0.0.0.0"]
