FROM python:slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends\
    libgomp1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install uv
RUN python -m pip install --upgrade pip
RUN python -m pip install uv

COPY . .

# Recreate uv environment and install dependencies
RUN uv venv --force
RUN uv pip install --no-cache -e ./
RUN uv run -m pipeline.training_pipeline

EXPOSE 5000


CMD ["uv", "run", "python", "-m", "application"]
