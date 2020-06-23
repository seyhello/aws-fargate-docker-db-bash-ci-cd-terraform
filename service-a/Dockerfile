FROM nginx

COPY service-a/wrapper.sh /

COPY service-a/html /usr/share/nginx/html

EXPOSE 80

CMD ["./wrapper.sh"]
