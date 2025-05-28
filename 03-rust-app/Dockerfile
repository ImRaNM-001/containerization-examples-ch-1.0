# Builder stage
FROM rust:1.77-alpine AS builder

WORKDIR /usr/src/app

RUN apk add --no-cache musl-dev
RUN rustup target add x86_64-unknown-linux-musl

COPY Cargo.toml .
COPY src src/

RUN cargo build --release --target x86_64-unknown-linux-musl

############################################
# FINAL STAGE (scratch for static, or alpine for dynamic)
############################################
FROM scratch

WORKDIR /app

COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/rust-todo /app/rust-todo

# copy initial data if needed here
# COPY --from=builder /usr/src/app/data /app/data

VOLUME ["/app/data"]

ENTRYPOINT ["/app/rust-todo"]

CMD ["list"]