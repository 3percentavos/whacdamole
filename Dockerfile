# Use the official Python base image
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Helm
ENV HELM_VERSION=v3.11.2
RUN curl -fsSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar zxvf - --strip-components=1 -C /usr/local/bin linux-amd64/helm

# Install Kubectl
ENV KUBECTL_VERSION=v1.23.0
RUN curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Copy the whacdamole script into the container
COPY whacdamole /usr/local/bin/whacdamole

# Make sure the script is executable
RUN chmod +x /usr/local/bin/whacdamole

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Expose port 8080 if necessary (for future expansions)
EXPOSE 8080

# Set the entrypoint to the whacdamole script
ENTRYPOINT ["whacdamole"]