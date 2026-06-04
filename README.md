# Docker for reproducible research

This repository is a companion to a tutorial for utilizing Docker to create containers for reproducible research with a focus on statistical methodology. Prior to the tutorial, please follow the below steps in preparation.

For an introduction to how Docker works, I encourage you to review the [What is Docker?](https://docs.docker.com/get-started/docker-overview/) article in their documentation. Another excellent resource is their [Docker workshop](https://docs.docker.com/get-started/workshop/). Though this focuses on application development, it is still a nice review of the basic functionality of Docker.

# Contents  
[Installing Docker](#installing-docker)  
&emsp; [Docker Desktop](#docker-desktop)  
&emsp; [Windows](#windows)  
&emsp; [macOS](#macos)  
&emsp; [Linux](#linux)  
[Docker for R](#docker-containers-for-r)  
[Getting started for tutorial](#getting-started-for-tutorial)

# Installing Docker

There are several options for installing Docker, and they vary based on the operating system. My personal preference is to use Docker from the command line using their command line interface (CLI) to manage containers and images. However, Docker also offers Docker Desktop, which is a one-click-install application that can be run on Mac, Linus, or Windows. Docker Desktop is a graphical user interface (GUI) for the same purpose. 

## Docker Desktop

Because of my bias towards using the Docker CLI, I encourage tutorial attendees to following along using the command line. For those who are interested in installing Docker Desktop and following along with that application, feel free to do so using the installation instructions [here](https://docs.docker.com/desktop/). Be sure to install the application for the correct operating system. Note that if you have trouble with Docker Desktop, I may be less capable of helping as I am much less familiar with that method of using Docker.

## Docker daemon and client (CLI)

### Windows

For those willing to dive into the Docker CLI, the first step is installing Windows Subsystem for Linux (WSL). WSL allows you to run a Linux environment on your Windows machine, without a separate virtual machine or dual booting. Follow this [installation tutorial](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL. Simply, open PowerShell and type
```
wsl --install
```
This installs Ubuntu by default, which is the Linux distribution that allows the most flexibility (and has the largest community for support) both generally and for using Docker. Once WSL is installed, skip down to the [Linux instructions below](#linux).

### macOS

Within the macOS environment, there are also several options for installing Docker. My suggestion is to install [OrbStack](https://orbstack.dev/). This is an alternative to Docker Desktop that is lightweight, fast, and simple to install and use. It also conveniently gives the option of running Linux machines, which can be helpful in some cases. Simply,
```
brew install orbstack
```
Take care that whenever you are interacting with Docker in the CLI, OrbStack should be running. Also note that if you quit OrbStack, your running containers will stop. I have made this mistake before!

### Linux

This section will focus on installation of the [Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/). If you plan to install Docker for a different Linux distribution, follow the [guide](https://docs.docker.com/engine/install/).

The below is adapted from the first link within this subsection. This may update over time, so please follow the link to be sure you are getting the most up-to-date instructions!

First, update Ubuntu packages:
```
sudo apt update && sudo apt upgrade -y
```
Second, uninstall conflicting packages:
```
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)
```
Next, setup the Docker `apt` repository:
```
# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
```
Then, install the Docker packages:
```
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
and verify that Docker is running:
```
sudo systemctl status docker
```
Lastly, confirm that the installation was successful:
```
sudo docker run hello-world
```

After installation, we perform the [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/). Again, for the most up-to-date commands, please follow the link. To avoid requiring `sudo` every time a Docker command is used, we create a `docker` user group:
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```
Verify that `docker` can now be run without `sudo`:
```
docker run hello-world
```
To configure Docker to start on boot,
```
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

# Docker containers for R

[The Rocker project](https://rocker-project.org/) is an open source repository with Docker containers that have many default R packages installed and are modular. An overview of the available images is [here](https://rocker-project.org/images/). 

Give this a try by pulling an image of RStudio:
```
docker run --rm -ti -e PASSWORD=yourpassword -p 8787:8787 rocker/rstudio
```
and point your browser to `localhost:8787`. Log in with user/password `rstudio/yourpassword`.

# Getting started for tutorial

Now that Docker is installed on your system, follow the following instructions prior to the tutorial, if possible.

1. `git clone` the repository.
2. In Github, navigate to the [`rstudio-env`](rstudio-env/) directory.
3. Follow the instructions in the `README`.
4. See you at the tutorial! :)
