# Build stage
FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux make build

# Final stage
FROM alpine:latest

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/tipsy .

# Set the binary as the entrypoint
ENTRYPOINT ["/app/tipsy"]