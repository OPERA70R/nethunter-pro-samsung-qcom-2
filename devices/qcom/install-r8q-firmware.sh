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

# Adreno 650 and IPA firmware used by the SM8250 platform.
install_firmware qcom/sm8250 \
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

# Qualcomm Bluetooth controller firmware.
install_firmware qca \
    htbtfw20.tlv \
    htnv20.bin

# ath11k QCA6390 firmware.
install_firmware ath11k/QCA6390/hw2.0 \
    qca6390/amss20.bin \
    qca6390/bdwlan.elf \
    qca6390/m3.bin \
    qca6390/regdb.bin

rm -rf "$src"
