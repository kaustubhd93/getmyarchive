## getmyarchive
getmyarchive is a tool that downloads linux packages with dependencies and creates a ready to install archive that can be installed on a linux server with no internet.

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
- `ubuntu_version` can have values 16.04,18.04,20.04,22.04
- This will download all packages required in a tar file of format f2a48f4a-0808-4ffa-8731-bd275544f327.tar.gz

### Run this on the destination server which has no internet.

- `tar -xvf f2a48f4a-0808-4ffa-8731-bd275544f327.tar.gz`
- `cd f2a48f4a-0808-4ffa-8731-bd275544f327`
- `sudo bash installpkgs.sh`
- This will install all packages that you had mentioned in pkglist.
