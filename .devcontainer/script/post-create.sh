#!/bin/env bash
#Description: Install to dependencies tools  ubuntu 22
#Author: jblanco33
#Fecha: 20250818

# version_terraform=1.5.1
# version_terragrunt=0.77.17

#https://github.com/terraform-docs/terraform-docs/releases/tag/v0.14.1




## Instalacion de paquetes
function installPackage() {

    apt-get update
    apt-get install -y ssh curl wget zip vim less gnupg software-properties-common watch netcat-traditional iproute2 jq yq iputils-ping 
    apt-get clean
    rm -rf /var/lib/apt/lists/*

} 


function configDns(){ 

    ## Configuracion de resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf

} 

function installAzureCli(){
    #Intala azureCli
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
    az aks install-cli

}

function installAwsCli(){
    #Instala awsCli
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    bash -c ./aws/install
    rm -rf aws awscliv2.zip 
}

function installKubectl(){
    #Instala kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /bin/kubectl
    ## Configuracion de alias
    echo "alias k=kubectl" >> /root/.bashrc
}
function installHelm(){
    #Instala Helm
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm get_helm.sh
}

function installTerraform(){
    #Instala Terraform
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" |  tee /etc/apt/sources.list.d/hashicorp.list
    apt update
    apt install terraform=1.5.1*
    #apt install terraform
}

function installTerragrunt(){
    #Instala Terragrunt

    wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.77.17/terragrunt_linux_amd64
    mv terragrunt_linux_amd64 terragrunt
    chmod +x terragrunt
    mv terragrunt /bin/terragrunt
} 

echo Configurando el contenedor...

installPackage
configDns
installAzureCli
#installAwsCli
installKubectl
installHelm
installTerraform
installTerragrunt

echo "Configuración finalizada."
echo "----------------------------------------"
echo "Resumen de instalación:"

GREEN='\033[0;32m'
NC='\033[0m' # Sin color

echo "Resumen de instalación:"
[ "$(type -t installPackage)" = "function" ] && echo -e "${GREEN}✔ Paquetes base instalados${NC}"
[ "$(type -t configDns)" = "function" ] && echo -e "${GREEN}✔ Configuración de DNS realizada${NC}"
[ "$(type -t installAzureCli)" = "function" ] && echo -e "${GREEN}✔ Azure CLI instalado${NC}"
[ "$(type -t installAwsCli)" = "function" ] && echo -e "${GREEN}✔ AWS CLI instalado y configurado${NC}"
[ "$(type -t installKubectl)" = "function" ] && echo -e "${GREEN}✔ Kubectl instalado${NC}"
[ "$(type -t installHelm)" = "function" ] && echo -e "${GREEN}✔ Helm instalado${NC}"
[ "$(type -t installTerraform)" = "function" ] && echo -e "${GREEN}✔ Terraform instalado${NC}"
[ "$(type -t installTerragrunt)" = "function" ] && echo -e "${GREEN}✔ Terragrunt instalado${NC}"
# ...existing code...
echo "----------------------------------------"
echo "Versiones instaladas:"
command -v terraform >/dev/null && echo -n "Terraform: " && terraform version | head -n 1
command -v terragrunt >/dev/null && echo -n "Terragrunt: " && terragrunt --version | head -n 1
command -v kubectl >/dev/null && echo -n "Kubectl: " && kubectl version --client | head -n 1
command -v helm >/dev/null && echo -n "Helm: " && helm version --short
command -v aws >/dev/null && echo -n "AWS CLI: " && aws --version