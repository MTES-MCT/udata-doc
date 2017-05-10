# uData installation for MEEM/MLHD

> **Installation on _amd64_ and _Debian Jessie_**

---

## 1. Post-Installation OS

> **Execute these commands as** ```root``` **user**

### 1.1 __Set the proxy environment variables persistently for all users__
```shell
$ echo 'http_proxy=http://<adresse_proxy:port_proxy>; export http_proxy' >> /etc/bash.bashrc
$ echo "https_proxy=http://<adresse_proxy:port_proxy>; export https_proxy" >> /etc/bash.bashrc
$ echo "no_proxy="localhost,127.0.0.1,.mondomaine"; export no_proxy" >> /etc/bash.bashrc
```

### 1.2 __Install some packages__
```shell
$ apt-get install bash-completion openssh-server sudo
```

### 1.3 __Create user for udata__
```shell
$ useradd -c "uData user" -m -s /bin/bash udata
$ passwd udata
```

### 1.4 __Add udata user to sudo group__
```shell
$ adduser udata sudo
```

### 1.5 __Configuration mail server relay__
```shell
$ sudo apt-get install mailutils exim4
```

### 1.6 __Create and set permissions of the udata directory__
```shell
$ cd /var
$ sudo mkdir myudata
$ sudo chown udata:udata myudata
```

---

## 2. System dependencies

> **Execute these commands as** ```udata``` **user**

### 2.1 __Git__
```shell
$ sudo apt-get install git-core
```

### 2.2 __Python requirements__
```shell
$ sudo apt-get install build-essential pkg-config python python-dev python-pip \
    libjpeg-dev zlib1g-dev libtiff5-dev libfreetype6-dev \
    liblcms2-dev libopenjpeg-dev libwebp-dev libpng12-dev \
    libxml2-dev  libxslt1-dev liblzma-dev libyaml-dev
```

### 2.3 __Docker__
#### 2.3.1 Installation
Install packages to allow ```apt``` to use a repository over HTTPS:
```shell
$ sudo apt-get install apt-transport-https ca-certificates curl gnupg2 software-properties-common
```
Add Docker's official GPG key:
```shell
$ curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
```
Verify that the key ID is ```9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88```
```shell
$ sudo apt-key fingerprint 0EBFCD88

pub   4096R/0EBFCD88 2017-02-22
  Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid                  Docker Release (CE deb) <docker@docker.com>
sub   4096R/F273FCD8 2017-02-22
```
Set up the stable repository for amd64
```shell
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
```
Install the latest version of Docker
```shell
$ sudo apt-get update
$ sudo apt-get install docker-ce
```
Verify that Docker is installed correctly by running the ```hello-world``` image.
```shell
$ sudo docker run hello-world
```
This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.

#### 2.3.2 Docker without sudo for udata user
We don't want to use ```sudo``` to run Docker commands
```shell
$ sudo groupadd docker
$ sudo usermod -aG docker udata
```
Verify that we can run Docker commands without ```sudo```
```shell
$ docker run hello-world
```

#### 2.3.3 Configure Docker to start on boot
```shell
$ sudo systemctl enable docker
```

#### 2.3.4 Docker behind proxy
Create a systemd drop-in directory for the docker service:
```shell
$ mkdir -p /etc/systemd/system/docker.service.d
```
Create a file called ```/etc/systemd/system/docker.service.d/http-proxy.conf``` that adds the ```HTTP_PROXY```, ```HTTPS_PROXY``` and ```NO_PROXY``` environment variable:
```shell
$ sudo nano /etc/systemd/system/docker.service.d/http-proxy.conf

[Service]
Environment="HTTP_PROXY=http://<adresse_proxy:port_proxy>/" "HTTPS_PROXY=http://<adresse_proxy:port_proxy>/" "NO_PROXY=localhost,127.0.0.1,.mondomaine"
```
Flush changes
````shell
$ sudo systemctl daemon-reload
```
Restart Docker
````shell
$ sudo systemctl restart docker
```

### 2.4 __Docker-compose__
Download the Docker Compose binary
```shell
sudo -i
curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
exit
```
Apply executable permissions to the binary
```shell
sudo chmod +x /usr/local/bin/docker-compose
```
Test the installation
```shell
docker-compose --version
```

## 3. Local dependencies

> **Execute these commands as** ```udata``` **user**

> **Execute these commands in udata directory** (```/var/myudata```)

### 3.1 __Retrieving udata sources__
Be careful because we are behind a proxy and with git
```shell
git config --global http.proxy http://<adresse_proxy:port_proxy>
git config --global https.proxy http://<adresse_proxy:port_proxy>
git config --global url."https://github.com/".insteadOf git://github.com/
```
Now we can clone the udata repository
```shell
git clone https://github.com/opendatateam/udata.git
```
### 3.2 __Python and virtualenv__
```shell
pip install --user virtualenv
/home/udata/.local/bin/virtualenv --python=python2.7 venv
source venv/bin/activate
pip install Cython
pip install -r requirements/develop.pip
pip install -e .
```
### 3.3 __NodeJS__
```shell
cd udata
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install
nvm use
```
We are behind a proxy, so:
```shell
npm config set proxy "http://<adresse_proxy:port_proxy>" -g
npm config set https-proxy "http://<adresse_proxy:port_proxy>" -g
```
Now we can use npm
```shell
npm install
```
