#!/bin/bash

# Laden van externe configuratie
source installatie.sh
source extensies.sh
source os_opties.sh
source vm_opties.sh

# Voeg deze regel toe aan het begin van je script
silent_mode=false

# Activeer logging
exec > >(tee vm_configuratie_log.txt)
exec 2>&1

# Functie om stilte modus te controleren
function check_silent_mode() {
    if [ "$silent_mode" = true ]; then
        exec > /dev/null 2>&1
    fi
}

# Functie voor verbeterde foutafhandeling
function handle_error() {
    local error_message=$1
    echo "Fout: $error_message"
    # Voeg hier stappen voor probleemoplossing toe indien mogelijk
    exit 1
}

# Functie voor meertalige ondersteuning
function set_language() {
    # Voeg hier logica toe om de taal in te stellen op basis van de systeeminstellingen
    language="nl"  # Vervang dit met de daadwerkelijke detectie
    echo "Taal ingesteld op: $language"
}

# Functie voor het weergeven van voortgangsindicator
function show_progress() {
    local message=$1
    echo -n "$message"
    sleep 1  # Simuleer enige activiteit
    echo " [Voltooid]"
}

# Functie om rechten van alle bestanden bij te werken
function update_file_permissions() {
    chmod +x *
    echo "Rechten van alle bestanden zijn bijgewerkt."
}

# Functie om het script af te sluiten
function exit_script() {
    echo "Bedankt voor het gebruik van het VirtualBox Setup Script!"
    exit 0
}

# Controleer of VirtualBox is geïnstalleerd
if ! command -v vboxmanage &> /dev/null; then
    echo "Error: VirtualBox is niet geïnstalleerd. Installeer VirtualBox voordat je dit script uitvoert."
    exit 1
fi

# Functie voor het weergeven van helpinformatie
function show_help() {
    echo "Dit is een interactief script voor VirtualBox-configuratie."
    echo "Beschikbare opties:"
    echo "1. Installeren VirtualBox"
    echo "2. Installeren Extensiepakket"
    echo "3. Aanmaken Virtuele Machine"
    echo "4. Toewijzen Opslag"
    echo "5. Toewijzen Netwerkadapter"
    echo "6. Stoppen/Herstarten Virtuele Machine"
    echo "7. Configureren Netwerkinstellingen"
    echo "8. Toevoegen Port Forwarding"
    echo "9. Versie tonen"
    echo "10. Help tonen"
    echo "11. Script Afsluiten"
    echo "12. Update rechten van alle bestanden"
    echo "13. Toon Gemaakte en Draaiende VMs"
    echo "Je kunt de functionaliteit uitbreiden door meer functies toe te voegen. Deze kun je aanroepen vanuit het menu." 
    echo
    echo "Voor hulp of suggesties kun je een pullrequest aanmaken."
    echo
    echo "Gun je mij een bakje koffie? Ik zal je bijdrage waarderen."
    echo "Doneren is mogelijk via de volgende link: https://gofundme.com/campagne-nr=000000"
    echo
    echo "Om dit script uit te voeren, maak het uitvoerbaar met het commando:"
    echo "chmod +x main.sh"
    echo "Voer het script vervolgens uit met:"
    echo "./main.sh"
    echo
}

# Hoofdmenu
PS3="Selecteer een optie: "
options=("Installeren VirtualBox" "Installeren Extensiepakket" "Aanmaken Virtuele Machine" "Toewijzen Opslag" "Toewijzen Netwerkadapter" "Stoppen/Herstarten Virtuele Machine" "Configureren Netwerkinstellingen" "Toevoegen Port Forwarding" "Versie tonen" "Help tonen" "Script Afsluiten" "Update rechten van alle bestanden")

select opt in "${options[@]}"; do
    case $opt in
        "Installeren VirtualBox")
            install_virtualbox
            ;;
        "Installeren Extensiepakket")
            install_extension_pack
            ;;
        "Aanmaken Virtuele Machine")
            create_vm
            ;;
        "Toewijzen Opslag")
            assign_storage
            ;;
        "Toewijzen Netwerkadapter")
            assign_network
            ;;
        "Stoppen/Herstarten Virtuele Machine")
            restart_vm
            ;;
        "Configureren Netwerkinstellingen")
            configure_network_settings
            ;;
        "Toevoegen Port Forwarding")
            add_port_forwarding
            ;;
        "Versie tonen")
            show_version
            ;;
        "Help tonen")
            show_help
            ;;
        "Toon Gemaakte en Draaiende VMs")
            list_running_vms
            ;;
        "Script Afsluiten")
            exit_script
            ;;
        "Update rechten van alle bestanden")
            update_file_permissions
            ;;
        *)
            echo "Ongeldige keuze. Kies een geldige optie."
            ;;
    esac
done
