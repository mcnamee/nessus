FROM ubuntu:bionic

RUN echo '--- Init ---' && \
    apt update && \
    apt dist-upgrade -y && \
    apt install -y --no-install-recommends \
      cron \
      curl \
      expect

RUN echo '--- Install Nessus ---' && \
    DL_LINK="https://www.tenable.com/downloads/nessus?loginAttempted=true" && \
    curl -L -k -s GET $DL_LINK > /tmp/tenable.txt && \
    VERSION=$( cat /tmp/tenable.txt | grep 'Nessus-' | sed -e 's/.*Nessus-\(.*\)-ubuntu1804_aarch64\.deb.*/\1/' ) && \
    ARCH=$( arch | sed s/aarch64/ubuntu1804_aarch64/ | sed s/x86_64/ubuntu1404_amd64/ ) && \
    FILENAME="Nessus-${VERSION}-${ARCH}.deb" && \
    curl -L -k \
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
