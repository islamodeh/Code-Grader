echo "Pulling ubuntu image.."
docker pull ubuntu;
echo "Configuring image"
docker rmi -f vm; # remove old vm image.
docker rm -f vm; # remove old vm.
docker run -itd --name vm ubuntu;
req=$(cat requirements.txt)
docker exec -it -e req="$req" vm /bin/sh -c 'echo "$req" > req.sh; chmod +x req.sh'
docker exec -it vm /bin/sh -c 'bash req.sh'
docker exec -it vm /bin/sh -c 'rm req.sh'
echo "Create user and password"
docker exec -it vm /bin/sh -c 'useradd code-grader'
docker exec -it vm /bin/sh -c 'echo "code-grader:M2R3V7gxFMaFx" | chpasswd'
docker exec -it vm /bin/sh -c 'mkdir /home/code-grader'
docker exec -it vm /bin/sh -c 'chown -R code-grader:code-grader /home/code-grader'
echo "run user using docker run --user code-grader"
docker commit vm vm;
echo "Removing container"
docker rm -f vm
