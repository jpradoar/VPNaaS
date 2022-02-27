FROM alpine:3.15.0
MAINTAINER "Jonathan Prado"
RUN apk update; apk add strongswan 
EXPOSE 500/udp 4500/udp 
ENTRYPOINT ["tail" "-f" "/dev/null"]


# Optional to run with prometheus and export metrics. :) 
#WORKDIR /data
#COPY ./node_exporter /data/node_exporter
#RUN apk update; apk add strongswan 
#EXPOSE 500/udp 4500/udp 9100/tcp
#ENTRYPOINT ["./node_exporter"]