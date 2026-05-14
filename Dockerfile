FROM ghcr.io/cirruslabs/flutter:stable

# Set the working directory
WORKDIR /app

# Copy the project files
COPY . .

# Ensure dependencies are fetched
RUN flutter pub get

# Expose the web server port
EXPOSE 8080

# Start the Flutter web server binding to 0.0.0.0 to allow external access
CMD ["flutter", "run", "-d", "web-server", "--web-hostname", "0.0.0.0", "--web-port", "8080"]
