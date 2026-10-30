FROM docker.io/ubuntu:26.04 AS builder
WORKDIR /tmp
# Install Git executable for git-revision-date-localized-plugin
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      git \
      python3 \
      python3-pip \
 && rm -rf /var/lib/apt/lists/*
# Copy Python packages/dependencies file
COPY requirements.txt .
# Install Python dependencies
RUN python3 -m pip install --no-cache-dir -r requirements.txt --break-system-packages
# Install headless browser for PDF file generation
RUN playwright install chromium --with-deps
# Copy .git folder for git-revision-date-localized-plugin
COPY .git .git
# Copy documentation source files to working directory
COPY docs docs
COPY mkdocs.yml .
COPY includes includes
# Build new documentation without PDF file generation as this needs a special base image
RUN mkdocs build

# Hardened image from https://images.redhat.com/?name=nginx
FROM registry.access.redhat.com/hi/nginx:latest
COPY --from=builder /tmp/site /usr/share/nginx/html
