FROM ubuntu:bionic

RUN echo '--- Init ---' && \
    apt update && \
    apt dist-upgrade -y && \
    apt install -y --no-install-recommends \
      cron \
      curl \
      expect

RUN echo '--- Install Nessus ---' && \
    VERSION="10.5.0" && \
    ARCH=$( arch | sed s/aarch64/ubuntu1804_aarch64/ | sed s/x86_64/ubuntu1404_amd64/ ) && \
    FILENAME="Nessus-${VERSION}-${ARCH}.deb" && \
    curl -v -k \
        --url https://www.tenable.com/downloads/api/v2/pages/nessus/files/$FILENAME \
        --output $FILENAME && \
    dpkg -i ${FILENAME} && \
    rm ${FILENAME} && \
    chmod +x /opt/nessus/sbin/nessusd && \
    chown root:root /opt/nessus/sbin/nessusd && \
    chmod +x /opt/nessus/sbin/nessus-service && \
    chown root:root /opt/nessus/sbin/nessus-service

RUN echo '--- Cleanup ---' && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/opt/nessus/sbin/nessusd"]
CMD ["start"]

EXPOSE 8834
