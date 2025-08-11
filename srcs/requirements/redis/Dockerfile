FROM debian:bullseye

EXPOSE 6379

RUN	apt update && \
	apt install -y --no-install-recommends --no-install-suggests \
	redis-server && \
	rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /usr/local/etc/redis/redis.conf

CMD ["redis-server", "/usr/local/etc/redis/redis.conf"]
