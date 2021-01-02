#!/bin/bash
# Run with sudo or as root user
echo "Checking for compatability..."
os=`grep -w ID /etc/os-release | awk -F"=" '{print $2}'`
if [ $os != "ubuntu" ]
then
    echo "Operating System not supported."
    exit 1
fi

if [ -z $1 ]
then
    echo "No options provided."
    echo "Usage : bash getarchive.sh <ubuntu_version>"
    echo "For example : bash getarchive.sh 16.04"
    exit 1
fi

cwd=`pwd`
pkglist=`cat pkglist`
req_id=`uuidgen`
archive_dir="/tmp/$req_id"
os_flavor="ubuntu"
os_version=$1

install_docker() {
    apt-get update
    echo "******************************************************************"
    echo "Installing docker..."
    echo "******************************************************************"
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common telnet
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io
    sleep 3
    docker_status=`systemctl is-active docker`
    if [[ "$docker_status" != "active" ]]
    then
        systemctl start docker
    fi
    docker run hello-world

}

is_pkg_installed () {
    pkg_status=`dpkg -s $1 | grep -w Status | awk -F": " '{print $2}'`
    if [[ $pkg_status != "install ok installed" ]]
    then
        install_docker
    else
        echo "$1 already installed."
    fi
}

is_pkg_installed "docker-ce"

echo "Starting container..."
docker run --name $req_id -id $os_flavor:$os_version
echo "Updating repositories..."
docker exec -it $req_id apt-get update
echo "Downloading deb files..."
for package in `echo $pkglist`
do
    mkdir -p $archive_dir/$package
    cd $archive_dir/$package
    docker exec -it $req_id apt-get install $package --print-uris  | grep http | awk '{print $1}' | xargs wget
    #cd ../..
    cd $cwd
done

echo "Cleaning up container..."
docker stop $req_id
docker rm $req_id

cp $cwd/pkglist $archive_dir/
cp $cwd/installpkgs.sh $archive_dir/
cd $archive_dir
tar -zcf $archive_dir.tar.gz ../$req_id
cd $cwd
echo "Removing temp download directory..."
rm -rf $archive_dir
echo "******************************************************************"
echo "The path to your archive is $archive_dir.tar.gz "
echo "******************************************************************"