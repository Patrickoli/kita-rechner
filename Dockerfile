FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY vendor /usr/share/nginx/html/vendor
EXPOSE 80
