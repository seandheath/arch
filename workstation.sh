#!/bin/bash

pacmanPackages=(
	neovim
	firefox
	git
	inkscape
	steam
	nextcloud-client
	bitwarden
	yay
	okular
	opensc
	ccid
	unzip
	wget
)

# Install packages
sudo pacman -Syyu --noconfirm $pacmanPackages

# Install DoD Certificates
if not test -d $HOME/.config/DoDCerts; then
	mkdir -p $HOME/.config/DoDCerts
	cd $HOME/.config/DoDCerts
	wget https://dl.dod.cyber.mil/wp-content/uploads/pki-pke/zip/certificates_pkcs7_DoD.zip
	unzip certificates_pkcs7_DoD.zip
	sudo trust anchor $HOME/.config/DoDCerts/Certificates_PKCS7_v5.9_DoD/DoD_PKE_PEM.pem
fi

# Set up CAC access for VMWare Horizons
if not test -f /usr/lib/vmware/view/pkcs11/libopenscpkcs11.so; then
	yay -S --noconfirm --answerdiff=None vmware-horizon-client vmware-horizon-usb vmware-horizon-smartcard
	sudo mkdir -p /usr/lib/vmware/view/pkcs11
	sudo ln -s /usr/lib64/pkcs11/opensc-pkcs11.so /usr/lib/vmware/view/pkcs11/libopenscpkcs11.so
fi

# Install mullvad
if not which mullvad; then
	yay -S --noconfirm --answerdiff=None mullvad-vpn
fi

# Install joplin
if not which joplin-dekstop; then
	yay -S --noconfirm --answerdiff=None joplin-appimage
fi

# Enable services
sudo systemctl enable --now pcscd
sudo systemctl enable --now vmware-horizon-usb
