## getmyarchive
A tool that downloads linux packages with dependencies and creates an archive that can be installed on a linux server with no internet.

## Tool usage

### Run this on a system that has internet access 

- `touch pkglist`
- Add a list of packages in file `pkglist`, for example:
    ```
    build-essential
    telnet
    nmap
    zip
    ```
- `sudo bash getarchive.sh <ubuntu_version>` 
- `ubuntu_version` can have values 16.04,18.04,20.04
- This will download all packages required in a tar file of format long-unique-id.tar.gz

### Run this on the destination server which has no internet.

- `tar -xvf long-unique-id.tar.gz`
- `cd long-unique-id`
- `sudo bash installpkgs.sh`
- This will install all packages that you had mentioned in pkglist.
