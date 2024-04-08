FROM ubuntu:22.04

RUN \
    # Add Docker's official GPG key:
    apt update && \
    apt install -y ca-certificates curl gnupg && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    # Add the repository to Apt sources:
    echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && \
    # Install the Docker packages.
    apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    sudo \
    apt-utils \
    neofetch \
    wget
WORKDIR /app
RUN pip3 install jupyterlab && \
  curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    sudo dpkg -i cloudflared.deb 
RUN echo 'sudo cloudflared service install eyJhIjoiNDdhNThhY2ZiNGI3NDU0ZmQ3M2RjNTFjMDgwNDI1YzkiLCJ0IjoiMzE4M2Q0ZmUtZWVjNy00MTU4LTg1NzItM2M4ODM3ZWI2N2UwIiwicyI6Ik1XRXhPVFpqT1dFdE5UUTNZeTAwWkRRMExUZ3pORGt0TVdSbE56Um1aVGsyTWpJMiJ9' >> start.sh
RUN echo 'jupyter lab --ip=0.0.0.0 --port=8080 --no-browser --allow-root --NotebookApp.token=""' >> start.sh
RUN chmod +x start.sh
EXPOSE 8080
CMD ["bash","./start.sh"]
