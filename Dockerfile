FROM python:slim

ENV PYTHONDONTWRITEBYTECODE = 1 \
    PYTHONUNBUFFERED = 1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends\
    libgomp1 \
    && app-get-clean \
    && rm -rf /var/lib/apt/lists/*

COPY . .

# RUN pip install --no-cache-dir .
RUN uv pip install --no-cache -e ./
RUN uv run -m pipeline.training_pipeline

EXPOSE 5000

# CMD ["python", "application.py"]
# CMD ["uv", "run", "python", "application.py"]
CMD ["uv", "run", "python", "-m", "application"]
