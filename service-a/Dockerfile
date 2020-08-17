FROM nginx:mainline

# Little bit confusing, it is working only for GitHub Actions
COPY service-a/wrapper.sh /
COPY service-a/html /usr/share/nginx/html

# Uncomment this to work in "local" Docker mode
# COPY wrapper.sh /
# COPY html /usr/share/nginx/html

EXPOSE 80

CMD ["./wrapper.sh"]
