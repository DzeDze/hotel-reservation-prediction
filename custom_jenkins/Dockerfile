# Use Jenkins 2.480 (Debian Bullseye) :
# VPN->I only found that tag 2.480 still works well with bulleys 
# and is compatible with docker-ce and docker-ce-cli and contanerd.io for now
# 29 Nov 2025
FROM jenkins/jenkins:2.480

# Switch to root user to install dependencies
USER root

# Install prerequisites and Docker
# update script to install python3-pip and libgomp1
RUN apt-get update -y && \
    apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        software-properties-common \
        python3-pip \
        libgomp1 && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian bullseye stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y \
        docker-ce  \
        docker-ce-cli \
        containerd.io  && \
    apt-get clean&& \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install uv
# --break-system-packages
# Safe because the container is ephemeral and isolated.
RUN python3 -m pip install --upgrade pip uv --break-system-packages

# Add Jenkins user to the Docker group (create if it doesn't exist)
RUN groupadd -f docker && \
    usermod -aG docker jenkins

# Create the Docker directory and volume for DinD
RUN mkdir -p /var/lib/docker
VOLUME /var/lib/docker

# Switch back to the Jenkins user
USER jenkins
