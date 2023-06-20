# Stage 1: Build stage
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add gcc libc-dev libffi-dev
RUN pip install --user --no-cache-dir PyGithub==1.58.2

# Stage 2: Final stage
FROM python:3.11-alpine

WORKDIR /app

# Copy the script
COPY main.py .

# Copy files from the builder stage
COPY --from=builder /root/.local /root/.local

# Set the environment variables
ENV PATH=/root/.local/bin:$PATH

# Run the script
CMD python main.py
