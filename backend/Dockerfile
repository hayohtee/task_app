# Build the application from source
FROM golang:1.23.5 AS build-stage

WORKDIR /app

COPY . ./

RUN go mod download

RUN CGO_ENABLED=0 GOOS=linux go build -o api ./cmd/api

# Run the tests in the container
FROM build-stage AS run-test-stage
RUN go test -v ./...

# Deploy the application binary into a lean image
FROM alpine:latest AS build-release-stage

WORKDIR /

COPY --from=build-stage /app/api .
COPY --from=build-stage /app/.env .

EXPOSE 4000

ENTRYPOINT [ "./api" ]