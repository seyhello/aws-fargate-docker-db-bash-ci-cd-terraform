FROM nginx

ARG BUILD_DIR=build
COPY ${BUILD_DIR}/html /usr/share/nginx/html

EXPOSE 80

CMD ["exec nginx -g "daemon off;""]
