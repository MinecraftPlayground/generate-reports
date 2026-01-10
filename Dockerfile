FROM eclipse-temurin:25-alpine

RUN apt-get update \
  && apt-get install -y curl jq zip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src

COPY ./main.sh .
RUN chmod +x /usr/src/main.sh

ENTRYPOINT ["/usr/src/main.sh"]
