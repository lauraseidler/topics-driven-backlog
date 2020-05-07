FROM ruby:2.4-alpine

# set variables
ENV APP_HOME /usr/src/app
ENV APPLICATION_ENVIRONMENT docker

# expose port 80 (rails server)
EXPOSE 80

# work in app dir
WORKDIR $APP_HOME

# Add gemfile stuff
COPY Gemfile* ./

# Add scripts
COPY .docker/* .docker/
RUN chmod +x .docker/wait-for-db.sh
RUN chmod +x .docker/prepare-db.sh

# general dependencies
RUN set -ex \
  && apk add --no-cache libpq imagemagick bash git

# nodejs fixed to v8
RUN set -ex \
  && apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ nodejs=8.9.3-r1

# https://github.com/npm/npm/issues/20861
RUN npm config set unsafe-perm true

# install yarn
RUN npm install --global yarn

# build deps
RUN set -ex \
  && apk add --no-cache --virtual .builddeps \
       linux-headers \
       libpq \
       tzdata \
       build-base \
       postgresql-dev \
       imagemagick-dev \
  && gem install bundler \
  && bundle install

# add all to be able to install yarn modules
ADD . .

# install yarn modules
RUN yarn install --ignore-engines

# start puma server AND webpack dev server (see Procfile)
CMD ["foreman", "start"]
