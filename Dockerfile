FROM golang:1.22 as go-build

WORKDIR /go/src/app
COPY /server .
RUN go mod download
RUN go vet -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM fischerscode/flutter:flutter-3.25-candidate.0 AS flutter-build
WORKDIR /flutterapp
COPY /client .
RUN flutter clean
RUN flutter pub get
RUN flutter build web --release

FROM gcr.io/distroless/static-debian11
WORKDIR /
COPY --from=go-build /go/bin/app .
COPY --from=flutter-build /flutterapp/build/web ./web
CMD ["/app"]