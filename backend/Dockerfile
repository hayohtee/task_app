FROM golang:1.23

WORKDIR /app

COPY . ./

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -o api ./cmd/api

EXPOSE 4000

CMD [ "api" ]