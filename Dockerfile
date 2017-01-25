FROM alpine:3.5

COPY build_nginx.sh /usr/local/bin
RUN apk add --update bash && \
    build_nginx.sh \
    && rm /usr/local/bin/build_nginx.sh
COPY nginx.conf /usr/local/nginx/conf/
COPY conf.d /usr/local/nginx/conf.d/
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
