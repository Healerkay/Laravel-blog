FROM php:8.2-apache

# Install required packages
RUN apt-get update && apt-get install -y \
    vim \
    nodejs \
    npm \
    unzip

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the Laravel project files into the container
COPY . /var/www/html

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) mysqli pdo pdo_mysql

# Install npm packages
RUN npm install

# Install Vite globally
RUN npm install -g create-vite

# Set up the project with Vite
RUN create-vite my-project

# Switch to the Vite project directory
WORKDIR /var/www/html/my-project

# Install dependencies for the Vite project
RUN npm install

# Expose port 80 (assuming your Laravel app runs on port 80)
EXPOSE 80

# Run vite in development mode
CMD ["npm", "run", "dev"]