# Installation de udata au sein du MEEM/MLHD

## Post installation OS 
Paramétrage du proxy
`export https_proxy=http://<adresse:port>`

`apt-get install bash-completion openssh-server sudo`

Modifier le fichier `/etc/group` pour ajouter un compte en sudo ; se positionner sur la ligne sudo et indiquer les noms des utilisateurs.

Installation du serveur relai de courriel
`sudo apt-get install  mailutils exim4`


## Installation des prérequis

Installation de git et de curl
`sudo apt-get install git-core curl`

Installation des prérequis udata
`sudo apt-get install build-essential pkg-config python python-dev python-pip \
    libjpeg-dev zlib1g-dev libtiff5-dev libfreetype6-dev \
    liblcms2-dev libopenjpeg-dev libwebp-dev libpng12-dev \
    libxml2-dev  libxslt1-dev liblzma-dev libyaml-dev`

Installation de docker-compose
`curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /tmp/docker-compose`
`sudo cp /tmp/docker-compose /usr/local/bin/docker-compose`
`sudo chmod +x /usr/local/bin/docker-compose`

Installation de docker engine
`sudo apt-get install apt-transport-https  ca-certificates software-properties-common`
`curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -`
`sudo add-apt-repository        "deb https://apt.dockerproject.org/repo/ \
	debian-$(lsb_release -cs) \
	main"`
`sudo apt-get update`
`sudo apt-get -y install docker-engine`

Paramétrage de docker dans le cas d'un proxy

`sudo vi /etc/systemd/system/docker.service.d/http-proxy.conf`
Ajouter les lignes suivantes :
`
[Service]
Environment="HTTP_PROXY=http://<adresse:port>"
Environment="HTTPS_PROXY=http://<adresse:port>"
`
Relance du service
`sudo systemctl restart docker.service`

## Installation de udata

`pip install udata`
`pip install udata-piwik udata-gouvfr udata-youckan uwsgi gevent raven`


## A mettre en forme...

(en root) pip install virtualenv
virtualenv --python=python2.7 venv
source venv/bin/activate

pip install -r udata/requirements/develop.pip
pip install -e udata/
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
export NVM_DIR="/home/adminstr/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install v6.9.4

cd udata
nvm install
nvm use
npm config set http-proxy http://<adresse:port>
npm config set https-proxy http://<adresse:port>
npm config set registry http://registry.npmjs.org/
npm set strict-ssl false
git config --global url.https://github.com/.insteadOf git://github.com/
npm install

inv assets_build

udata init
udata licenses https://www.data.gouv.fr/api/1/datasets/licenses

docker-compose up -d

tx pull 
inv i18nc


sudo a2enmod proxy proxy_http
sudo service apache2 restart
sudo a2ensite datalake

