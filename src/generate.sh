#!env bash

source ./warp
source ./windows_terminal
source ./iterm2

SCHEMES="cosmic_red cosmic_blue cosmic_green cosmic_yellow"

BASE_BRIGHT_BLACK="626262"
BASE_BRIGHT_WHITE="FFFFFF"
BASE_BLACK="121212"
BASE_WHITE="F1F1F1"

SRC_DIR="$(dirname $0)"
DIST_DIR="${SRC_DIR}/../dist"

# Check if ImageMagick is installed
if ! which convert &> /dev/null; then
    echo "Color scheme generation requires ImageMagick!"
    exit 1
fi

if [ -d "${DIST_DIR}" ]; then
    rm -rf "${DIST_DIR}"
fi

mkdir "${DIST_DIR}"

for SCHEME in ${SCHEMES}; do
    echo -n "Generating color scheme ${SCHEME}... "

    source "./${SCHEME}"

    SCHEME_DIR="${DIST_DIR}/${SCHEME}"

    # Creating directory
    mkdir "${SCHEME_DIR}"

    # Copying base files
    cp "${SRC_DIR}/cosmic_base.jpg" "${SCHEME_DIR}/${SCHEME}.jpg"
    cp "${SRC_DIR}/palette_base.png" "${SCHEME_DIR}/palette_${SCHEME}.png"

    # Tinting images
    convert "${SCHEME_DIR}/${SCHEME}.jpg" -fill "${TINT_COLOR}" -tint "${BG_TINT:-$TINT_VALUE}" "${SCHEME_DIR}/${SCHEME}.jpg"
    convert "${SCHEME_DIR}/palette_${SCHEME}.png" -fill "${TINT_COLOR}" -tint "${TINT_VALUE}" "${SCHEME_DIR}/palette_${SCHEME}.png"

    BRIGHT_BLACK="${OVERWRITE_BRIGHT_BLACK:-${BASE_BRIGHT_BLACK}}"
    BRIGHT_WHITE="${OVERWRITE_BRIGHT_WHITE:-${BASE_BRIGHT_WHITE}}"

    BRIGHT_BLUE="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{1,1\}] info:)"
    BRIGHT_CYAN="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{2,1\}] info:)"
    BRIGHT_GREEN="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{3,1\}] info:)"
    BRIGHT_MAGENTA="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{4,1\}] info:)"
    BRIGHT_RED="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{5,1\}] info:)"
    BRIGHT_YELLOW="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{6,1\}] info:)"

    BLACK="${OVERWRITE_BLACK:-${BASE_BLACK}}"
    WHITE="${OVERWRITE_WHITE:-${BASE_WHITE}}"

    BLUE="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{7,1\}] info:)"
    CYAN="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{8,1\}] info:)"
    GREEN="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{9,1\}] info:)"
    MAGENTA="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{10,1\}] info:)"
    RED="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{11,1\}] info:)"
    YELLOW="$(convert ${SCHEME_DIR}/palette_${SCHEME}.png -format %[hex:u.p\{12,1\}] info:)"

    generate_warp "${SCHEME_DIR}/${SCHEME}.Warp.yml"
    generate_windows_terminal "${SCHEME_DIR}/${SCHEME}.WindowsTerminal.json"
    generate_iterm2 "${SCHEME_DIR}/${SCHEME}.itermcolors"

    rm "${SCHEME_DIR}/palette_${SCHEME}.png"
   
    echo "Done!"
done