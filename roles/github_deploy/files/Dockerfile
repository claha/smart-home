# Stage 1: Build stage
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add --no-cache gcc==12.2.1_git20220924-r10 libc-dev==0.7.2-r5 libffi-dev==3.4.4-r2 && \
    pip install --user --no-cache-dir PyGithub==2.1.1 ansible==8.5.0 homeassistant-cli==0.9.6 jmespath==1.0.1

# Stage 2: Final stage
FROM python:3.11-alpine

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git==2.40.1-r0 openssh==9.3_p2-r0

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
