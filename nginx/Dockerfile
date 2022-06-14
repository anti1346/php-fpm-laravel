FROM nginx:stable

COPY ./nginx.conf /etc/nginx/nginx.conf

COPY ./default.conf /etc/nginx/conf.d/default.conf

entrypoint.sh

CMD ["nginx", "-g", "daemon off;"]





### docker build
# docker build --no-cache -t anti1346/nginx:1.21.6 .
#
### docker buildx(m1)
# docker buildx build --platform linux/amd64 --load --no-cache -t anti1346/nginx:1.21.6-amd64 .