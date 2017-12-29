# Topics Driven Backlog

[![Build Status](https://travis-ci.org/mvuajua/topics-driven-backlog.svg?branch=master)](https://travis-ci.org/mvuajua/topics-driven-backlog)
[![codecov](https://codecov.io/gh/mvuajua/topics-driven-backlog/branch/develop/graph/badge.svg)](https://codecov.io/gh/mvuajua/topics-driven-backlog)

## Requirements
- Installation of Docker and Docker Compose

## Startup
Run `npm run dev` to start up the dev environment. Browse app at [localhost:8080](http://localhost:8080).

## Working with the app
Run `npm run bash` to open a bash shell on the docker machine.  

Edit Gemfile and then run `npm run bundle:update` to install new gems.

To create and seed (if db does not exist) or migrate (if db does exist) the database, run `npm run db:migrate`.

## Shutdown
Run `npm stop` to properly shut down the container.