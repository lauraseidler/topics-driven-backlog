# README

## Requirements
- Installation of Docker and Docker Compose

## Startup
Run `docker-compose up` to start up the docker machine, leave the prompt open. Browse app at [localhost:8080](http://localhost:8080).

## Working with the app
Run `docker exec -ti tdb-dev bash` to open a bash shell on the docker machine.  

Edit Gemfile and then run `bundle update` in the docker bash to install new gems

## Shutdown
Run `docker-compose down` to properly shut down the container, the running prompt should exit automatically.