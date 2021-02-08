# 
# Lean base image, as you requested 

FROM node:alpine

WORKDIR /usr/app

# Let's deal with the dependencies first. They do not change often, so it makes sense to install them first

COPY ./package.json ./
RUN npm install
# most often cache will be used until this point, so builds should be fairly quick

# Do not want to run as root anymore
USER node:node 

# copy application code now as well. 
COPY ./ ./

# default start up command for dev time
CMD ["npm", "start"]



   
