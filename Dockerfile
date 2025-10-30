# Use Alpine Linux minimal image
FROM alpine:latest

# Set Julia version
ENV JULIA_VERSION=1.11.2
ENV JULIA_PATH=/usr/local/julia
ENV PATH=$JULIA_PATH/bin:$PATH

# Install dependencies and Julia binary
RUN apk add --no-cache wget ca-certificates tar gzip libgcc libstdc++ && \
    mkdir -p $JULIA_PATH && \
    wget -q https://julialang-s3.julialang.org/bin/musl/x64/1.11/julia-${JULIA_VERSION}-musl-x86_64.tar.gz && \
    tar -xzf julia-${JULIA_VERSION}-musl-x86_64.tar.gz -C $JULIA_PATH --strip-components=1 && \
    rm julia-${JULIA_VERSION}-musl-x86_64.tar.gz && \
    apk del wget tar gzip

# Set working directory
WORKDIR /app

# Copy package files
COPY Project.toml ./
COPY src/ ./src/

# Install package dependencies
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); Pkg.precompile()'

# Set default command to Julia REPL
CMD ["julia", "--project=."]
