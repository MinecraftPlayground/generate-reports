FROM eclipse-temurin:25-alpine

RUN apk add --no-cache curl jq

WORKDIR /usr/src

COPY ./main.sh .
RUN chmod +x /usr/src/main.sh

ENTRYPOINT ["/usr/src/main.sh"]
