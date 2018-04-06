FROM ubuntu:16.04

# See https://crbug.com/795759
ENV DEBIAN_FRONTEND=noninteractive
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
RUN apt-get update && apt-get install -y apt-utils
RUN apt-get install -yq libgconf-2-4 wget curl

# Install latest chrome dev package and fonts to support major charsets (Chinese, Japanese, Arabic, Hebrew, Thai and a few others)
# Note: this installs the necessary libs to make the bundled version of Chromium that Puppeteer
# installs, work.
#

RUN apt-get update && apt-get install -y wget --no-install-recommends \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst ttf-freefont \
      --no-install-recommends

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get update \
    && apt-get -y install nodejs git vim

# Clone the tests repo
RUN git clone https://github.com/Bnei-Baruch/archive-tests-js.git
WORKDIR /archive-tests-js

#Config to run headless and no sendbox
RUN sed -i "s#.*puppeteer\.launch.*#            browser = await puppeteer.launch({args: ['--no-sandbox', '--headless'], executablePath: '/opt/google/chrome/google-chrome'});#g" spec/spec.js

# Install the all the mohules
RUN npm i
