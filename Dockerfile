# Build stage
FROM golang:1.22-alpine as builder

WORKDIR /app
COPY go.mod main.go /app/

RUN go build -o goreleaser

# Final stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates
COPY --from=builder /app/goreleaser /app/goreleaser

ENTRYPOINT ["/app/goreleaser"]
