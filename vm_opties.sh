#!/bin/bash

# Functie voor het aanmaken van een virtuele machine
function create_vm() {
    if ! $vm_created; then
        read -p "Voer de naam van de virtuele machine in: " vm_name
        read -p "Voer het geheugen (RAM) in MB in: " vm_memory
        read -p "Voer het aantal CPU-kernen in: " vm_cpus

        echo "Aanmaken van virtuele machine: $vm_name..."
        vboxmanage createvm --name "$vm_name" --ostype "Other" --register
        vboxmanage modifyvm "$vm_name" --memory "$vm_memory" --cpus "$vm_cpus" --ioapic on
        vm_created=true
        echo "Virtuele machine $vm_name is aangemaakt!"
    else
        echo "Een virtuele machine is al aangemaakt."
    fi
}

# Functie voor het toewijzen van opslag aan de virtuele machine
function assign_storage() {
    check_vm_created
    if ! $storage_assigned; then
        read -p "Voer de naam van het opslagmedium in: " storage_name
        read -p "Voer de grootte van het opslagmedium in GB in: " storage_size

        echo "Toewijzen van opslagmedium $storage_name aan virtuele machine $vm_name..."
        vboxmanage createmedium disk --filename "$storage_name" --size "$storage_size" --format VDI
        vboxmanage storagectl "$vm_name" --name "SATA Controller" --add sata --controller IntelAhci
        vboxmanage storageattach "$vm_name" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$storage_name.vdi"
        storage_assigned=true
        echo "Opslagmedium $storage_name is toegewezen aan virtuele machine $vm_name!"
    else
        echo "Opslagmedium is al toegewezen aan virtuele machine $vm_name."
    fi
}

# Functie voor het toewijzen van een netwerkadapter aan de virtuele machine
function assign_network() {
    check_vm_created
    if ! $network_assigned; then
        read -p "Voer het type netwerkadapter in (bridged, nat, hostonly): " network_type

        case $network_type in
            "bridged")
                read -p "Voer de naam van de bridged-interface in: " bridge_interface
                vboxmanage modifyvm "$vm_name" --nic1 bridged --bridgeadapter1 "$bridge_interface"
                ;;
            "nat")
                vboxmanage modifyvm "$vm_name" --nic1 nat
                ;;
            "hostonly")
                vboxmanage modifyvm "$vm_name" --nic1 hostonly
                ;;
            *)
                echo "Ongeldige keuze. Kies een geldig type netwerkadapter."
                assign_network
                ;;
        esac

        network_assigned=true
        echo "Netwerkadapter van type $network_type is toegewezen aan virtuele machine $vm_name!"
    else
        echo "Netwerkadapter is al toegewezen aan virtuele machine $vm_name."
    fi
}

# Functie voor het stoppen en opnieuw starten van de virtuele machine
function restart_vm() {
    check_vm_created
    if $network_assigned; then
        read -p "Wil je de virtuele machine stoppen of opnieuw starten? (stop/restart): " restart_option
        case $restart_option in
            "stop")
                echo "Stoppen van virtuele machine $vm_name..."
                vboxmanage controlvm "$vm_name" poweroff
                ;;
            "restart")
                echo "Herstarten van virtuele machine $vm_name..."
                vboxmanage controlvm "$vm_name" reset
                ;;
            *)
                echo "Ongeldige keuze. Kies een geldige optie."
                restart_vm
                ;;
        esac
    else
        echo "Voordat je de virtuele machine kunt stoppen of opnieuw starten, moet je eerst een netwerkadapter toewijzen."
    fi
}

# Functie voor het configureren van netwerkinstellingen binnen de virtuele machine
function configure_network_settings() {
    check_vm_created
    if $network_assigned; then
        read -p "Voer het IP-adres in dat je wilt toewijzen aan de virtuele machine: " vm_ip
        read -p "Voer het subnetmasker in: " vm_subnet
        read -p "Voer het gateway-adres in: " vm_gateway

        echo "Configureren van netwerkinstellingen binnen de virtuele machine $vm_name..."
        vboxmanage guestproperty set "$vm_name" "/VirtualBox/GuestInfo/Net/0/V4/IP" "$vm_ip"
        vboxmanage guestproperty set "$vm_name" "/VirtualBox/GuestInfo/Net/0/V4/Netmask" "$vm_subnet"
        vboxmanage guestproperty set "$vm_name" "/VirtualBox/GuestInfo/Net/0/V4/Gateway" "$vm_gateway"
        echo "Netwerkinstellingen binnen de virtuele machine $vm_name zijn geconfigureerd!"
    else
        echo "Voordat je netwerkinstellingen kunt configureren, moet je eerst een netwerkadapter toewijzen aan de virtuele machine."
    fi
}

# Functie voor het toevoegen van port forwarding voor publieke toegang
function add_port_forwarding() {
    check_vm_created
    if $network_assigned; then
        read -p "Voer het hostpoortnummer in voor port forwarding: " host_port
        read -p "Voer het gastpoortnummer in voor port forwarding: " guest_port

        echo "Toevoegen van port forwarding voor publieke toegang naar virtuele machine $vm_name..."
        vboxmanage controlvm "$vm_name" natpf1 "guestssh,tcp,,$host_port,,$guest_port"
        echo "Port forwarding toegevoegd voor publieke toegang: $host_port -> $guest_port"
    else
        echo "Voordat je port forwarding kunt toevoegen, moet je eerst een netwerkadapter toewijzen aan de virtuele machine."
    fi
}

# Functie voor het weergeven van gemaakte en draaiende virtuele machines
function list_running_vms() {
    echo "Lijst van gemaakte en draaiende virtuele machines:"
    
    # Gebruik vboxmanage om informatie op te halen over draaiende virtuele machines
    running_vms=$(vboxmanage list runningvms)
    
    if [ -n "$running_vms" ]; then
        echo "Draaiende virtuele machines:"
        echo "$running_vms"
    else
        echo "Er zijn geen draaiende virtuele machines op dit moment."
    fi

    # Gebruik vboxmanage om informatie op te halen over alle virtuele machines
    all_vms=$(vboxmanage list vms)

    if [ -n "$all_vms" ]; then
        echo "Alle virtuele machines:"
        echo "$all_vms"
    else
        echo "Er zijn geen gemaakte virtuele machines op dit moment."
    fi
}

# Functie voor het weergeven van gemaakte en draaiende virtuele machines
function list_running_vms() {
    echo "Lijst van gemaakte en draaiende virtuele machines:"
    
    # Gebruik vboxmanage om informatie op te halen over draaiende virtuele machines
    running_vms=$(vboxmanage list runningvms)
    
    if [ -n "$running_vms" ]; then
        echo "Draaiende virtuele machines:"
        echo "$running_vms"
    else
        echo "Er zijn geen draaiende virtuele machines op dit moment."
    fi

    # Gebruik vboxmanage om informatie op te halen over alle virtuele machines
    all_vms=$(vboxmanage list vms)

    if [ -n "$all_vms" ]; then
        echo "Alle virtuele machines:"
        echo "$all_vms"
    else
        echo "Er zijn geen gemaakte virtuele machines op dit moment."
    fi
}

# Verwijder Virtuele Machine(s)
function remove_vm() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in die je wilt verwijderen: " vm_to_remove
    vboxmanage unregistervm "$vm_to_remove" --delete
    echo "Virtuele machine $vm_to_remove is verwijderd."
}

# Bekijk Virtuele Machine Details
function view_vm_details() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in waarvan je details wilt bekijken: " vm_to_view
    vboxmanage showvminfo "$vm_to_view"
}

# Snapshot Maken van Virtuele Machine
function take_snapshot() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in waarvan je een snapshot wilt maken: " vm_to_snapshot
    read -p "Voer de naam van het snapshot in: " snapshot_name
    vboxmanage snapshot "$vm_to_snapshot" take "$snapshot_name"
    echo "Snapshot $snapshot_name is gemaakt voor virtuele machine $vm_to_snapshot."
}

# Herstel Virtuele Machine naar Snapshot
function restore_snapshot() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in waarvan je een snapshot wilt herstellen: " vm_to_restore
    read -p "Voer de naam van het snapshot in dat je wilt herstellen: " snapshot_to_restore
    vboxmanage snapshot "$vm_to_restore" restore "$snapshot_to_restore"
    echo "Snapshot $snapshot_to_restore is hersteld voor virtuele machine $vm_to_restore."
}

# Lijst met Snapshots voor Virtuele Machine Weergeven
function list_snapshots() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in waarvan je de snapshots wilt bekijken: " vm_to_list_snapshots
    vboxmanage snapshot "$vm_to_list_snapshots" list
}

# Maak een Kloon van Virtuele Machine
function clone_vm() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in die je wilt klonen: " vm_to_clone
    read -p "Voer de naam van de nieuwe gekloonde virtuele machine in: " cloned_vm_name
    vboxmanage clonevm "$vm_to_clone" --name "$cloned_vm_name" --register
    echo "Virtuele machine $cloned_vm_name is gekloond van $vm_to_clone."
}
 
# Pas Virtuele Machine Instellingen Aan
function modify_vm_settings() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in waarvan je de instellingen wilt aanpassen: " vm_to_modify
    echo "Huidige instellingen:"
    vboxmanage showvminfo "$vm_to_modify"
    read -p "Voer de nieuwe geheugengrootte (RAM) in MB in: " new_memory_size
    read -p "Voer het nieuwe aantal CPU-kernen in: " new_cpu_count
    vboxmanage modifyvm "$vm_to_modify" --memory "$new_memory_size" --cpus "$new_cpu_count"
    echo "Instellingen zijn aangepast voor virtuele machine $vm_to_modify."
}

# Start Virtuele Machine in Headless Modus
function start_headless_vm() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in die je in headless modus wilt starten: " headless_vm_name
    vboxmanage startvm "$headless_vm_name" --type headless
    echo "Virtuele machine $headless_vm_name is gestart in headless modus."
}

# Stop Alle Draaiende Virtuele Machines
function stop_all_vms() {
    vboxmanage controlvm $(vboxmanage list runningvms | cut -d" " -f1) poweroff
    echo "Alle draaiende virtuele machines zijn gestopt."
}

# Herstart Virtuele Machine vanuit Gast OS
function restart_vm_guest() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in die je vanuit het gastbesturingssysteem wilt herstarten: " vm_to_restart_guest
    vboxmanage guestcontrol "$vm_to_restart_guest" run --exe "/sbin/reboot" --username <gebruikersnaam> --password <wachtwoord>
    echo "Virtuele machine $vm_to_restart_guest is herstart vanuit het gastbesturingssysteem."
}

# Toon Gastbesturingssysteem Informatie
function show_guest_info() {
    check_vm_created
    read -p "Voer de naam van de virtuele machine in waarvan je gastbesturingssysteeminformatie wilt tonen: " vm_for_guest_info
    vboxmanage guestproperty enumerate "$vm_for_guest_info"
}
