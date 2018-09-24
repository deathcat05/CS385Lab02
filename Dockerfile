FROM alpine:3.8

COPY bin/minibank /bin/minibank
ENV port=8080
EXPOSE 80
CMD ["/bin/minibank"]

