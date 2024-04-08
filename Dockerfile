FROM docker:26-dind
RUN apk add --no-cache \
    python3 \
    py3-pip \
    curl \
    sudo \
    neofetch \
    wget 
WORKDIR /app
RUN pip3 install jupyterlab && \
    wget -O cloudflared.deb --no-check-certificate https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    apk add dpkg && dpkg -i cloudflared.deb || true && apk del dpkg
RUN echo 'cloudflared service install' >> start.sh
RUN echo 'jupyter lab --ip=0.0.0.0 --port=8080 --no-browser --allow-root --NotebookApp.token=""' >> start.sh
RUN chmod +x start.sh
EXPOSE 8080
CMD ["sh","./start.sh"]
