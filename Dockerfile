# Use an official Nginx base image
FROM nginx:latest

# Copy the application code into the container
COPY . /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80
