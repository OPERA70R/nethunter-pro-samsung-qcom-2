#!/bin/sh

SCRIPT="$0"
DEVICE="$1"
IMAGE="$2"

[ "$IMAGE" ] || exit 1

CONFIG="$(dirname "${SCRIPT}")/configs/${DEVICE}.toml"
if ! [ -f "${CONFIG}" ]; then
    echo "WARN: No configuration for device type '${DEVICE}'; skipping boot image extraction"
    exit 0
fi

# Extract all supported variants from config
VARIANTS="$(tomlq -r 'foreach .device[] as $dev (0;
    if $dev.variant then
        [$dev.model, $dev.variant] | join("-")
    else
        $dev.model
    end
)' "${CONFIG}")"

for variant in ${VARIANTS}; do
    echo "Extracting boot image for variant ${variant}"
    if [ -s "${ROOTDIR}/bootimg-${variant}" ]; then
        if ! mv "${ROOTDIR}/bootimg-${variant}" "${ARTIFACTDIR}/${IMAGE}.boot-${variant}.img"; then
            echo "WARN: unable to extract boot image for variant ${variant}; skipping extraction"
            continue
        fi
    else
        echo "WARN: boot image for variant ${variant} was not generated; skipping extraction"
        continue
    fi
done
