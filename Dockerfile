FROM ruby:2.4-alpine

ENV APP_HOME /usr/src/app
ENV TDB_ENVIRONMENT docker

EXPOSE 80

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
COPY docker/* /docker/
RUN chmod +x /docker

# general dependencies
RUN set -ex \
  && apk add --no-cache libpq imagemagick nodejs bash

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

RUN chmod +x /docker/wait-for-db.sh
RUN chmod +x /docker/prepare-db.sh

CMD export QMAKE=/usr/lib/qt5/bin/qmake
CMD export PATH=/usr/lib/qt5/bin/qmake:$PATH
