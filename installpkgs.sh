#!/bin/bash
os=`grep -w ID /etc/os-release | awk -F"=" '{print $2}'`
if [ $os != "ubuntu" ]
then
    echo "Operating System not supported."
    exit 1
fi

pkglist=`cat pkglist`
for package in `echo $pkglist`
do
    cd $package
    ls -lrt *.deb | grep -v total | awk '{print $9}' | xargs dpkg -i --force-all
    cd ..
done

