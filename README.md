# Moodle Development Environment (Moodle Dev Env )

A small project that will clone and configure the "Moodle" and "Moodle-Docker" projects, and provide shell scripts to control the docker containers, in order to allow an easy context from which we can develop Plugins. 

### Quickstart
* Make sure `docker-compose` is installed (and available from the cmd-line)
* Open a terminal window
* Run the following from the project root: `./script.sh up`

### Commands
* To see all available commands: `./script.sh` 
* To run the server: `./script.sh up` 
* To stop the server `./script.sh down` 

### Gotchas
* Do not run script from Eclipse, it doesn't have access to `docker-compose` so if you run the `script.sh` from there it will complain. 