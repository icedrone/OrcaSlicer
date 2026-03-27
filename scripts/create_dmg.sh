#!/usr/bin/env bash
#
# Creates a professional macOS DMG installer for OrcaSlicer.
# Requires: create-dmg (brew install create-dmg)
#
# Usage: scripts/create_dmg.sh <app_path> <output_dmg_path> [volume_name]
#
set -euo pipefail

APP_PATH="${1:?Usage: $0 <app_path> <output_dmg_path> [volume_name]}"
OUTPUT_DMG="${2:?Usage: $0 <app_path> <output_dmg_path> [volume_name]}"
VOLUME_NAME="${3:-OrcaSlicer}"

# Resolve repo root relative to this script
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BACKGROUND="${REPO_ROOT}/resources/dmg/dmg_background.png"
VOLICON="${REPO_ROOT}/resources/dmg/dmg_icon.icns"
APP_NAME="$(basename "${APP_PATH}")"

# Validate inputs
if [ ! -d "${APP_PATH}" ]; then
    echo "Error: App bundle not found: ${APP_PATH}" >&2
    exit 1
fi

if [ ! -f "${BACKGROUND}" ]; then
    echo "Error: DMG background not found: ${BACKGROUND}" >&2
    exit 1
fi

if ! command -v create-dmg &>/dev/null; then
    echo "Error: create-dmg not found. Install with: brew install create-dmg" >&2
    exit 1
fi

# Remove existing DMG if present (create-dmg won't overwrite)
rm -f "${OUTPUT_DMG}"

echo "Creating DMG: ${OUTPUT_DMG}"
echo "  App: ${APP_PATH}"
echo "  Volume: ${VOLUME_NAME}"

# create-dmg returns exit code 2 when DMG is created successfully
# but Finder sync has a warning. This is normal and expected.
set +e
create-dmg \
    --volname "${VOLUME_NAME}" \
    --volicon "${VOLICON}" \
    --background "${BACKGROUND}" \
    --window-pos 200 120 \
    --window-size 660 400 \
    --icon-size 128 \
    --icon "${APP_NAME}" 170 200 \
    --hide-extension "${APP_NAME}" \
    --app-drop-link 490 200 \
    --no-internet-enable \
    --format UDZO \
    "${OUTPUT_DMG}" \
    "${APP_PATH}"
EXIT_CODE=$?
set -e

if [ ${EXIT_CODE} -ne 0 ] && [ ${EXIT_CODE} -ne 2 ]; then
    echo "Error: create-dmg failed with exit code ${EXIT_CODE}" >&2
    exit ${EXIT_CODE}
fi

echo "DMG created successfully: ${OUTPUT_DMG}"
