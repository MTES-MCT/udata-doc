# Installation de udata au sein du MEEM/MLHD

## Post installation OS 
Paramétrage du proxy
```shell
export https_proxy=http://<adresse:port>
```

Ajout de packages OS debian
```shell
apt-get install bash-completion openssh-server sudo
```

Ajout d'un compte existant dans le groupe des utilisateurs à pouvoir
Modifier le fichier `/etc/group` : se positionner sur la ligne sudo et indiquer les noms des utilisateurs concernés.

Installation du serveur relai de courriel

```shell
sudo apt-get install  mailutils exim4
```

## Installation des prérequis

Installation de git, de curl et des prérequis udata
```shell
sudo apt-get install git-core curl
sudo apt-get install build-essential pkg-config python python-dev python-pip \
    libjpeg-dev zlib1g-dev libtiff5-dev libfreetype6-dev \
    liblcms2-dev libopenjpeg-dev libwebp-dev libpng12-dev \
    libxml2-dev  libxslt1-dev liblzma-dev libyaml-dev
```

Installation de docker-compose
```shell
curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /tmp/docker-compose
sudo cp /tmp/docker-compose /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

Installation de docker engine
```shell
sudo apt-get install apt-transport-https  ca-certificates software-properties-common
curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
sudo add-apt-repository        "deb https://apt.dockerproject.org/repo/ \
	debian-$(lsb_release -cs) \
	main"
sudo apt-get update
sudo apt-get -y install docker-engine
```

Paramétrage de docker dans le cas d'un proxy
```shell
sudo vi /etc/systemd/system/docker.service.d/http-proxy.conf
```

Ajouter les lignes suivantes :
```python
[Service]
Environment="HTTP_PROXY=http://<adresse:port>"
Environment="HTTPS_PROXY=http://<adresse:port>"
```

Relance du service
```shell
sudo systemctl restart docker.service
```

## Installation de udata
```shell
pip install udata
pip install udata-piwik udata-gouvfr udata-youckan uwsgi gevent raven
```

## Post installation de udata

```shell
(en root) pip install virtualenv
virtualenv --python=python2.7 venv
source venv/bin/activate
pip install -r udata/requirements/develop.pip
pip install -e udata/
```

Installer nvm (et l'activer sans se déconnecter)
```shell
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
export NVM_DIR="/home/adminstr/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install v6.9.4
cd udata
nvm install
nvm use
```

Installer npm
```shell
npm config set http-proxy http://<adresse:port>
npm config set https-proxy http://<adresse:port>
npm config set registry http://registry.npmjs.org/
npm set strict-ssl false
git config --global url.https://github.com/.insteadOf git://github.com/
npm install
```

Installer les assets de udata
```shell
inv assets_build
udata init
udata licenses https://www.data.gouv.fr/api/1/datasets/licenses
```

Paramétrer tx
(à complèter)


Finir l'installation de udata
```shell
tx pull 
inv i18nc
```

## Installation d'un reverse proxy en frontal de udata
```shell
sudo a2enmod proxy proxy_http
```

Créer un fichier `datalake.conf` dans `/etc/apache2/sites-enabled/` avec des lignes suivantes
```
<VirtualHost *:80>
ProxyPass / http://localhost:7000/
        ProxyPassReverse / http://localhost:7000/
        ProxyPreserveHost Off
</VirtualHost>
```

Relancer le service apache et activer le paramétrage
```shell
sudo service apache2 restart
sudo a2ensite datalake
```

## A mettre en forme...

Lancement des services
docker-compose up -d


[uData]: https://github.com/opendatateam/udata

