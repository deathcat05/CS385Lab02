FROM alpine:3.8

COPY bin/minibank /bin/minibank
EXPOSE 80
CMD ["/bin/minibank"]

