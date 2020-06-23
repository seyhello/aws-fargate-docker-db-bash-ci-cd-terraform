FROM nginx

COPY service-b/wrapper.sh /

COPY service-b/html /usr/share/nginx/html

EXPOSE 80

CMD ["./wrapper.sh"]
