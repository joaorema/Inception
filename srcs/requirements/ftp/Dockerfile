FROM debian:bullseye

EXPOSE 21 30000-30009

RUN apt-get update && \
    apt-get install -y --no-install-recommends vsftpd && \
    rm -rf /var/lib/apt/lists/*

# Required by vsftpd secure_chroot_dir
RUN mkdir -p /var/run/vsftpd/empty

# Copy config and entrypoint script
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/setup.sh /setup.sh

RUN echo "/bin/bash" >> /etc/shells

# Mark script as executable
RUN chmod +x /setup.sh


ENTRYPOINT ["/setup.sh"]



