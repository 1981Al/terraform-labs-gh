RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function __updateSO (){
     apt update -y
     apt upgrade -y
     apt dist-upgrade -y
     apt autoremove -y
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
            echo -e "${RED}ERROR: No se ha podido actualizar el sistema de forma adecuada.\nRevise la operacion${NC}"
            exit 1
    fi
    echo -e "${GREEN}INFO: El Sistema se actualizo de forma correcta${NC}"
}

function __install_ssh(){
    apt update && apt install -y openssh-client
}

# Install wget, curl, vim
function __installCommon (){
    # apt install wget curl vim net-tools dos2unix unzip jq p7zip-full p7zip-rar unrar telnet ca-certificates apt-transport-https lsb-release gnupg gnupg2 -y
     apt-get install  apt-utils wget curl \
        net-tools dnsutils dos2unix unzip jq p7zip-full \
        p7zip-rar unrar telnet ca-certificates \
        apt-transport-https lsb-release gnupg gnupg2 \
        gawk software-properties-common ca-certificates -y
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
            echo -e "${RED}ERROR: Existio un problema al instalar las common.\nRevise la operacion.${NC}"
            exit 1
    fi
    echo -e "${GREEN}INFO: Las common se instalaron de forma correcta${NC}"
    echo "$(wget --version | grep 'GNU Wget')"
    echo "$(curl --version)"
    echo "$(vim --version | grep 'VIM - Vi IMproved')"
    echo "$(dos2unix --version | grep 'dos2unix ')"
}

# install python3
function __installPython3 () {
    local exist=$(which python3)
    if [ -z "$exist" ]; then
    # apt install python3 -y
         apt-get install python3.10 python3-pip -y
    fi
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
            echo -e "${RED}ERROR: Python 3 no se instalo de forma correcta.\nRevise la operacion${NC}"
            exit 1
    fi
    echo -e "${GREEN}INFO: Python 3 se instalo de forma correcta.${NC}"
    echo "$(python3 --version)"
}

# install git
function __installGit (){
    local exist=$(which git)
    if [ -z "$exist" ]; then
         apt install git -y
    fi
    exit_code=$?
    if [ $exit_code -ne 0 ]; then
            echo -e "${RED}ERROR: git no se instalo de forma correcta.\nRevise la operacion.${NC}"
            exit 1
    fi
    echo -e "${GREEN}INFO: Git se instalo de forma correcta: $(git --version)${NC}"
}