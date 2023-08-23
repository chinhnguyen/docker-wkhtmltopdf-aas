FROM ubuntu:jammy

RUN apt update
RUN apt upgrade -y
RUN apt install -y build-essential xorg libssl-dev libxrender-dev wget gdebi
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.jammy_amd64.deb
RUN gdebi --n wkhtmltox_0.12.6.1-2.jammy_amd64.deb

RUN wget -qO- https://deb.nodesource.com/setup_18.x | bash
RUN apt install -y nodejs

ADD package.json /package.json
ADD package-lock.json /package-lock.json

RUN npm install

ADD app.mjs /app.mjs

EXPOSE 80

CMD ["node", "app.mjs"]
