FROM node:18-alpine
WORKDIR /app

# Install json-server and copy data
RUN npm install -g json-server@0.17.1
COPY db.json /app/db.json

EXPOSE 3000
USER node
CMD ["json-server", "--watch", "db.json", "--host", "0.0.0.0", "--port", "3000"]
