FROM node:argon

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app
RUN rm -Rf node_modules
RUN npm install


ENV CONFIG_DIR /config

COPY . /usr/src/app
COPY ./config/config.sample.json /config/config.json

EXPOSE 8282
CMD [ "npm", "start" ]
