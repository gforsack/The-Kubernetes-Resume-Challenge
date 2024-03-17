# Use the official PHP 7.4 Apache base image
FROM php:7.4-apache

# Install mysqli extension for PHP
RUN docker-php-ext-install mysqli

# Set environment variables for database connection
ENV DB_HOST=mysql-service
ENV DB_PORT=3306
ENV DB_USER=ecomuser
ENV DB_PASSWORD=ecompassword
ENV DB_NAME=ecomdb

# Copy the application source code to /var/www/html/
COPY ./learning-app-ecommerce /var/www/html/

# Update database connection strings to point to a Kubernetes service named mysql-service
# Replace the following placeholders with your actual database connection details
RUN sed -i 's/localhost/mysql-service/g' /var/www/html/index.php

# Set the working directory
WORKDIR /var/www/html/

# Expose port 80 for Apache
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
