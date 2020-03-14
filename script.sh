#!/bin/bash

#	PURPOSE: 	Initialize and Run the Docker Environment to use with the moodle codebase
#
#				This file will check to see if there the two docker images needed
#				have been cloned and are ready to support the development environment
#				needed for Moodle Plugins.


# Directory Vars
dir_root=$PWD
dir_bin="$dir_root/bin"
dir_moodle="$dir_bin/moodle"
dir_moodle_docker="$dir_bin/moodle-docker"
dir_moodle_docker_bin="$dir_bin/moodle-docker/bin"

# Repo Vars
repo_moodle="https://github.com/moodle/moodle.git"
repo_moodle_docker="https://github.com/paulito-bandito/moodle-docker"

# STEP 1: INIT EXPORTS

	export MOODLE_DOCKER_WWWROOT=$dir_moodle
	
	# Choose a db server (Currently supported: pgsql, mariadb, mysql, mssql, oracle)
	export MOODLE_DOCKER_DB=pgsql
	
	# Hopefully the person running this script has docker-compose installed, we 
	# need to export it into the script environment if so the Moodle-Docker project
	# can use it (we are calling it's scripts indirectly)
	export docker-compose
	
# STEP 1b: INIT repos
	
	# Check to see if the bin folder exists, if it does, then assume this project is already configured. 
	if [ ! -d $dir_bin ]; then
	  	
	  	echo "* bin folder doesn't exist, creating..."
	  	mkdir -p $dir_bin;
	  
	  	git clone $repo_moodle_docker $dir_moodle_docker
	  	git clone $repo_moodle $dir_moodle
	  
	  
		# Ensure customized config.php for the Docker containers is in place
		cp "$dir_moodle_docker/config.docker-template.php" $MOODLE_DOCKER_WWWROOT/config.php
		
		# STEP 1a: Open port 9000 in the config file so we can install XDebugger later
		echo "      - 9000:9000" >> ./bin/moodle-docker/webserver.port.yml
		
	fi
	
	if [ -d $dir_bin ]; then
		echo "* Bin folder exists: no need to re-clone the projects."
	fi
	

# STEP 2: RUN

	case "$1" in
	
	"up" | "1")
	    # Start up containers
		/bin/bash "$dir_moodle_docker_bin/moodle-docker-compose" "up" "-d"
		
		# Wait for DB to come up (important for oracle/mssql)
		/bin/bash "$dir_moodle_docker_bin/moodle-docker-wait-for-db"
	
		echo "DB is up";
	    ;;
    "down" | "2")
	    # Shut down and destroy containers
		/bin/bash "$dir_moodle_docker_bin/moodle-docker-compose" "down"
	    ;;
	    
   "init behat tests" | "3")
	    # Initialize behat environment
		bin/moodle-docker-compose exec webserver php admin/tool/behat/cli/init.php
		;; 
		
	"init behat tests" | "4")
	    # Run behat tests
		bin/moodle-docker-compose exec -u www-data webserver php admin/tool/behat/cli/run.php --tags=@auth_manual
		;; 

	*)
		echo " "
		echo "Available Commands: "
		echo "  up (1)"
	    echo "  down (2)"
	    echo "  init behat tests (3)"
	    echo "  run behat tests (4)"
	esac

	
	
	
	