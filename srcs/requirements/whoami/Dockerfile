FROM debian:bullseye

RUN apt-get update && apt-get install -y netcat

COPY setup.sh /setup.sh
RUN chmod +x /setup.sh

CMD ["/setup.sh"]
