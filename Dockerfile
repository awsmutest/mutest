FROM node:10-alpine

# Create app directory
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# Install dependencies
COPY package.json .
RUN npm install
# 
# Bundle app source
COPY . .
USER node
# Exports
EXPOSE 3000

CMD [ "npm", "start" ]
