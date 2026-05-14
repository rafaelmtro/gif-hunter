FROM node:20-alpine

WORKDIR /app

# Install dependencies first for better caching
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Ensure next is executable
RUN chmod +x node_modules/.bin/next

EXPOSE 3000

CMD ["npm", "run", "dev"]
