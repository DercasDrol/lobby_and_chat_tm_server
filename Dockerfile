FROM golang:1.22 as go-build

WORKDIR /go/src/app
COPY /server .
RUN go mod download
RUN go vet -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM fischerscode/flutter:latest AS flutter-build
WORKDIR /flutterapp
COPY /client .
RUN flutter clean
RUN flutter pub get
RUN flutter build web

FROM gcr.io/distroless/static-debian11

COPY --from=flutter-build /flutterapp/build/web /web
COPY --from=go-build /go/bin/app /
CMD ["/app"]