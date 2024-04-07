FROM golang:1.22 as build

WORKDIR /go/src/app
COPY . .

RUN go mod download
RUN go vet -v

RUN CGO_ENABLED=0 go build -o /go/bin/app

FROM fischerscode/flutter:latest AS build-env
WORKDIR /flutterapp
RUN git clone https://github.com/DercasDrol/tm_web_flutter_client


WORKDIR /flutterapp/tm_web_flutter_client
RUN git pull https://github.com/DercasDrol/tm_web_flutter_client
RUN flutter clean
RUN flutter pub get
RUN flutter build web

FROM gcr.io/distroless/static-debian11

COPY --from=build-env /flutterapp/tm_web_flutter_client/build/web /web
COPY --from=build /go/bin/app /
CMD ["/app"]