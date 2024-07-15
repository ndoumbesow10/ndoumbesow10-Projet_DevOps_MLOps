<<<<<<< HEAD
# Projet_DevOps_MLOps
=======
# PAPE BELELE DIA & NDOUMBE SOW
=======
# Projet Terraform pour Azure VM et Déploiement d'API Docker

Ce projet contient les fichiers de configuration pour créer une machine virtuelle Azure, installer Docker et Git, cloner un dépôt GitHub, et déployer une API en utilisant Terraform.

## Fichiers

- `main.tf` : Le fichier de configuration Terraform pour configurer les ressources Azure.
- `install.sh` : Le script shell pour installer Docker, Git et déployer l'API.
- `README.md` : Ce fichier.

## Prérequis

- [Terraform](https://www.terraform.io/downloads.html) installé
- [Azure CLI](https://docs.microsoft.com/fr-fr/cli/azure/install-azure-cli) installé

## Étapes

### 1. Initialiser Terraform

```sh
terraform init
### 2. Appliquer la configuration Terraform

terraform apply

Confirmez l'action en tapant yes lorsque demandé.



-----------------------------------------------------------------------------------------------------
### Détails du Script

Le script install.sh effectue les actions suivantes :

    Met à jour la liste des paquets et installe les paquets nécessaires
    Installe Docker et Git
    Clone le dépôt API depuis GitHub
    Construit et exécute le conteneur Docker
    Installe et configure Nginx comme proxy inverse
	

### Détails de main.tf

Le fichier main.tf configure les ressources suivantes sur Azure :

    Un groupe de ressources
    Un réseau virtuel et un sous-réseau
    Une interface réseau
    Une machine virtuelle Ubuntu
    Un groupe de sécurité réseau avec une règle pour autoriser le trafic HTTP
    Une extension de script personnalisé pour installer et configurer Docker, Git, et l'API

Utilisation

Après avoir exécuté terraform apply, la machine virtuelle sera créée et configurée automatiquement pour exécuter l'API Pokedex via Docker et Nginx.
>>>>>>> a352151 (Initial commit)
