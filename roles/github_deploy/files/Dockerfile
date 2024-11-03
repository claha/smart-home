# Stage 1: Build stage
FROM python:3.13-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add --no-cache gcc==13.2.1_git20231014-r0 libc-dev==0.7.2-r5 libffi-dev==3.4.4-r3 && \
    pip install --user --no-cache-dir PyGithub==2.3.0 ansible==9.4.0 homeassistant-cli==0.9.6 jmespath==1.0.1

# Stage 2: Final stage
FROM python:3.13-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git==2.43.0-r0 openssh==9.6_p1-r0

# Copy the script
COPY main.py .

# Add knowns hosts
COPY known_hosts /root/.ssh/known_hosts

# Copy files from the builder stage
COPY --from=builder /root/.local /root/.local

# Set the environment variables
ENV PATH=/root/.local/bin:$PATH

# Run the script
CMD ["python", "main.py"]
