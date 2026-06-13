FROM node:20-alpine

WORKDIR /app

COPY package.json /app/package.json
RUN npm install

COPY report.js /app/report.js

CMD ["node", "report.js"]
