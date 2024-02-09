#!/bin/bash

function install_extension_pack() {
    if ! $installed_extension_pack; then
        echo "Optioneel: Extensiepakket installeren..."
        read -p "Wil je het standaard extensiepakket installeren? (ja/nee): " install_option
        if [ "$install_option" == "ja" ]; then
            default_ext_pack_path="https://download.virtualbox.org/virtualbox/7.0.14/Oracle_VM_VirtualBox_Extension_Pack-7.0.14.vbox-extpack"
            download_and_install_ext_pack "$default_ext_pack_path"
        else
            read -p "Voer het pad naar het extensiepakket in: " ext_pack_path
            download_and_install_ext_pack "$ext_pack_path"
        fi
    else
        echo "Extensiepakket is al geïnstalleerd."
    fi
}
