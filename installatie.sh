#!/bin/bash

# Installeer Virtualbox
function install_virtualbox() {
    if ! $installed_virtualbox; then
        echo "Installeren van VirtualBox... (Om het pakket te installeren heeft u sudo rechten nodig)"
        read -p "Wil je het standaard pakket installeren? (ja/nee): " install_option
        sudo apt-get update
        sudo apt-get install -y virtualbox
        installed_virtualbox=true
        echo "VirtualBox is geïnstalleerd!"
    else
        echo "VirtualBox is al geïnstalleerd."
    fi
}

