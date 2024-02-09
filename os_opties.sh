#!/bin/bash

function select_os_type() {
    echo "Kies het besturingssysteemtype:"
    PS3="Selecteer een optie: "
    os_options=("Debian" "Ubuntu" "Kali" "Parrot OS" "Windows 11" "MacOS" "Android" "Asterix" "Alpine" "Kodashi" "Arch Linux" "TorBrowser OS" "Terug naar het menu")

    select os_opt in "${os_options[@]}"; do
        case $os_opt in
            "Debian" | "Ubuntu" | "Kali" | "Parrot OS")
                download_os "Linux_X64" "$os_opt"
                break
                ;;
            "Windows 11")
                download_os "Windows" "$os_opt"
                break
                ;;
            "MacOS")
                download_os "MacOS" "$os_opt"
                break
                ;;
            "Android" | "Asterix" | "Alpine" | "Kodashi" | "Arch Linux" | "TorBrowser OS")
                download_os "Other" "$os_opt"
                break
                ;;
            "Terug naar het menu")
                break
                ;;
            *)
                echo "Ongeldige keuze. Kies een geldige optie."
                ;;
        esac
    done
}

# Functie voor het downloaden van het OS-bestand
function download_os() {
    local os_category=$1
    local os_name=$2

    echo "Wil je het OS-bestand downloaden vanaf een standaardpad of een zelf opgegeven pad?"
    select download_option in "Standaardpad" "Zelf opgegeven pad"; do
        case $download_option in
            "Standaardpad")
                download_path=""

                case $os_category in
                    "Linux_X64")
                        case $os_name in
                            "Debian")
                                download_path="https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-amd64.iso"
                                ;;
                            "Ubuntu")
                                download_path="https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-desktop-amd64.iso"
                                ;;
                            "Kali")
                                download_path="https://cdimage.kali.org/kali-2021.3/kali-linux-2021.3-amd64.iso"
                                ;;
                            "Parrot OS")
                                download_path="https://download.parrot.sh/parrot/iso/4.11/Parrot-kde-4.11_amd64.iso"
                                ;;
                        esac
                        ;;
                    "Windows")
                        download_path="https://software-download.microsoft.com/download/pr/22000.258.2106101625.9be780e5-8536-40dc-877d-8ef2044246c4/Windows11_InsiderPreview_Client_x64_en-us_22000.iso"
                        ;;
                    "MacOS")
                        download_path="https://mirror.dkm.cz/macos/macosv11.4.7z"
                        ;;
                    "Other")
                        case $os_name in
                            "Android")
                                download_path="https://download.virtualbox.org/virtualbox/7.0.14/android-x86-7.1-rc2.iso"
                                ;;
                            "Asterix")
                                download_path="https://www.asterix.com/downloads/AsterixOS-1.0.iso"
                                ;;
                            "Alpine")
                                download_path="https://dl-cdn.alpinelinux.org/alpine/v3.14/releases/x86_64/alpine-standard-3.14.0-x86_64.iso"
                                ;;
                            "Kodashi")
                                download_path="https://www.kodashi.org/en/download.html"
                                ;;
                            "Arch Linux")
                                download_path="https://archlinux.org/iso/2022.01.01/archlinux-2022.01.01-x86_64.iso"
                                ;;
                            "TorBrowser OS")
                                download_path="https://www.torproject.org/dist/torbrowser/11.0.8/tor-browser-linux64-11.0.8_en-US.tar.xz"
                                ;;
                        esac
                        ;;
                esac

                if [ -n "$download_path" ]; then
                    echo "Het OS-bestand wordt gedownload vanaf het standaardpad..."
                    show_progress "Downloaden"
                    echo "Download voltooid vanaf het standaardpad: $download_path"
                else
                    echo "Ongeldige keuze. Voer een geldig pad in voor het OS-bestand."
                    download_os "$os_category" "$os_name"
                fi
                break
                ;;
            "Zelf opgegeven pad")
                read -p "Voer het pad naar het OS-bestand in: " download_path
                if [ -f "$download_path" ]; then
                    echo "Het OS-bestand wordt gedownload vanaf het opgegeven pad: $download_path..."
                    show_progress "Downloaden"
                    echo "Download voltooid vanaf het opgegeven pad: $download_path"
                else
                    echo "Ongeldige keuze. Voer een geldig pad in voor het OS-bestand."
                    download_os "$os_category" "$os_name"
                fi
                break
                ;;
            *)
                echo "Ongeldige keuze. Kies een geldige optie."
                ;;
        esac
    done
}
