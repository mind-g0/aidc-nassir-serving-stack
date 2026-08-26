FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

# Copy uv directly from the official Astral image (Fastest & most reliable method)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Set working directory
WORKDIR /app

# Set up Hugging Face cache
ENV HF_HOME=/app/.cache/huggingface
RUN mkdir -p $HF_HOME 

# Install standard Python (since we removed pip, we explicitly ask for python3)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements.txt
COPY requirements.txt .

# Install PyTorch with CUDA 12.4 support first, then install remaining dependencies
# --system flag is required because uv prevents installing into the system Python by default
RUN uv pip install --system --no-cache --retries 5 --timeout 300 torch==2.5.* --index-url https://download.pytorch.org/whl/cu124 && \
    uv pip install --system --no-cache -r requirements.txt

# Copy the project
COPY . .

# Expose the port
EXPOSE 8000

# Start the application (ensure uvicorn uses python3 explicitly if needed, but standard is fine)
CMD ["python3", "-m", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]