#!/bin/bash
# Requires: git, vagrant, packer, vmware workstation

#BASE=WIN10_ENT
BASE=WIN10_ENT_LTSB
#BASE=WIN10_ISO


## Windows 10 90 Day Enterprise Trials
WIN10_ENT_NAME="Windows 10 Enterprise Evaluation - 1607 Anniversary Edition"
WIN10_ENT_ISO_URL="http://care.dlservice.microsoft.com/dl/download/C/3/9/C399EEA8-135D-4207-92C9-6AAB3259F6EF/10240.16384.150709-1700.TH1_CLIENTENTERPRISEEVAL_OEMRET_X64FRE_EN-US.ISO"
WIN10_ENT_CHECKSUM="56ab095075be28a90bc0b510835280975c6bb2ce"

WIN10_ENT_LTSB_NAME="Windows 10 Enterprise Evaluation LTSB - 1607 Anniversary Edition"
WIN10_ENT_LTSB_ISO_URL="http://care.dlservice.microsoft.com/dl/download/1/B/F/1BFE5194-5951-452C-B62C-B2F667F9B86D/14393.0.160715-1616.RS1_RELEASE_CLIENTENTERPRISE_S_EVAL_X64FRE_EN-US.ISO"
WIN10_ENT_LTSB_CHECKSUM="ed6e357cba8d716a6187095e3abd016564670d5b"

WIN10_ISO_NAME="Windows 10"
WIN10_ISO_ISO_URL="iso/XXX.ISO"
WIN10_ISO_CHECKSUM=""

##
NAME="${BASE}_NAME"
ISO_URL="${BASE}_ISO_URL"
CHECKSUM="${BASE}_CHECKSUM"

git clone https://github.com/joefitzgerald/packer-windows.git packer-windows

cd packer-windows

## 
if [[ "$BASE" == "WIN10_ENT_LTSB" ]] ; then
	echo Change the Autounattend to support LTSB release
	cp answer_files/10/Autounattend.xml{,.bak}
	sed '{s/Windows 10 Enterprise Evaluation/Windows 10 Enterprise 2016 LTSB Evaluation/g}' answer_files/10/Autounattend.xml > answer.xml
	mv answer.xml answer_files/10/Autounattend.xml
fi

packer build -only=vmware-iso -var iso_url=${!ISO_URL} -var iso_checksum=${!CHECKSUM} -var ssh_wait_timeout="4h" windows_10.json

# Add box to vagrant
vagrant box add --name "\"${!NAME} $(date)\"" windows_10_vmware.box 


