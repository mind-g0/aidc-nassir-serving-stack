# Use the official FastAPI uvicorn image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Copy requirements.txt
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir \
    --index-url https://download.pytorch.org/whl/cpu --extra-index-url https://pypi.org/simple \
    -r requirements.txt

# Copy the project
COPY . .

# Expose the port
EXPOSE 8000

# Start the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]`