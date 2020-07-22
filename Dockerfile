FROM golang:alpine AS build-env
WORKDIR .
COPY . /go-app
RUN cd /go-app && go build .

FROM alpine
#Alpine is one of the lightest linux containers out there, only a few MB
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk*
WORKDIR /app
COPY --from=build-env /go-app /app
COPY --from=build-env /go-app/templates /app/templates
COPY --from=build-env /go-app/static /app/static
#Here we copy the binary from the first image (build-env) to the new alpine container as well as the html and css

EXPOSE 8080
ENTRYPOINT [ "./welcome-app" ]