#!/bin/sh

set -eu

src=/tmp/r8q-firmware
fw=/lib/firmware

install_firmware() {
    subdir=$1
    shift

    for name in "$@"; do
        if [ ! -s "$src/$name" ]; then
            echo "Required r8q firmware file is missing: $src/$name" >&2
            exit 1
        fi
        install -D -m 0644 "$src/$name" "$fw/$subdir/$name"
    done
}

# Adreno 650 and IPA firmware request names used by the Qualcomm drivers.
install_firmware qcom \
    a650_gmu.bin \
    a650_sqe.fw \
    ipa_fws.b00 \
    ipa_fws.b01 \
    ipa_fws.b02 \
    ipa_fws.b03 \
    ipa_fws.b04 \
    ipa_fws.elf \
    ipa_fws.mdt \
    ipa_uc.b00 \
    ipa_uc.b01 \
    ipa_uc.b02 \
    ipa_uc.elf \
    ipa_uc.mdt

# Qualcomm Bluetooth controller firmware request paths.
install_firmware qca \
    htbtfw20.tlv \
    htnv20.bin

# QCA6390 Wi-Fi firmware is supplied by the distribution's firmware-atheros
# package. The Android-style amss20/bdwlan files in the local drop are not the
# ath11k firmware-5.bin and board-2.bin files requested by the upstream driver;
# do not install them under misleading names.
rm -rf "$src"
