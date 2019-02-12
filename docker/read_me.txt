1- To install docker, run docker_install.sh
2- Add your commands inside requirements.txt file, make sure the file includes first:
	a: apt-get update -y ;
	b: apt-get upgrade -y ;
3- run prepare_machine.sh which creates a virtual machine, runs the commands you specified in the file requirments.txt and create
	a new image of your virtual name called vm. run " docker images " to see your new image.
