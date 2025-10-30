# Use official Julia image as base
FROM julia:1.11

# Set working directory
WORKDIR /app

# Copy package files
COPY Project.toml ./
COPY src/ ./src/

# Install package dependencies
RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate(); Pkg.precompile()'

# Set default command to Julia REPL
CMD ["julia", "--project=."]
