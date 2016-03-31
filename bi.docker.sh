#!/usr/bin/env bash
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

function check_bin {
	if hash $1>/dev/null; then
	    echo -e "${GREEN}found "$1 $NC
	else
	    echo $1' not installed'
	    exit
	fi
}

check_bin git
check_bin vagrant
check_bin docker
check_bin docker-compose

ssh git@github.com
if [ "$?" -ne "1" ]; then
	echo -e "${RED}git is not configured correctly, did you setup ssh key?${NC}"
	exit
fi

if [ -d "brightidea" ]; then
  echo -e "${RED}brightidea folder alread exist, delete it and try again${NC}"
  exit
fi


read -p "Enter your github username (short handle): " github_handle


while true; do
    read -p "Did you fork the main repo?[Y/N]" yn
    case $yn in
        [Yy]* ) 
			mkdir brightidea
			cd brightidea
			git clone git@github.com:$github_handle/main.git
			if [ "$?" -ne "0" ]; then
				echo -e "${RED}No you didn't... Please fork the main repo.${NC}"
				cd ..
				rm -rf brightidea
			fi
			break
		;;
        * ) 
			echo -e "${RED}Please fork the main repo.${NC}";;
    esac
done

cd main
git remote add upstream git@github.com:brightideainc/main.git
git fetch upstream
git checkout -b bi/qa upstream/bi/qa
git checkout -b bi/stage upstream/bi/stage
git branch -d master
git checkout -b master upstream/master
cd ..
git clone git@github.com:brightideainc/devops.git
cp -r devops/vagrant/* .

echo -e "${GREEN}all done${NC}"