# Use Ubuntu as base image (closest to macOS for testing)
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV ANSIBLE_HOST_KEY_CHECKING=False
ENV PATH="/home/testuser/.local/bin:${PATH}"

# Install required packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    ansible \
    git \
    curl \
    zsh \
    sudo \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Install Ansible collection
RUN ansible-galaxy collection install community.general

# Create test user
RUN useradd -m -s /bin/zsh testuser \
    && echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy project files
COPY --chown=testuser:testuser . /home/testuser/setup-macos/

# Ensure git_vars.yml exists in test environment
COPY --chown=testuser:testuser test/test_git_vars.yml /home/testuser/setup-macos/git_vars.yml

# Set working directory
WORKDIR /home/testuser/setup-macos

# Entry point
CMD ["/bin/bash"] 