# Build phase
FROM golang:latest AS builder
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
WORKDIR /build/cmd
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o go-binary

# Production phase
FROM alpine:latest
WORKDIR /app
COPY --from=builder /build/cmd/go-binary .
ENTRYPOINT [ "/app/go-binary"]