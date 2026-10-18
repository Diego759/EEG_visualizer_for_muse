#!/bin/bash
# macOS diagnostic. Scans for nearby Bluetooth LE devices and reports whether
# this Mac can see the Muse headband. Keeps its window open so you can read the
# results. macOS may prompt for Bluetooth permission the first time.

cd "$(dirname "$0")" || exit 1
SCRIPT_DIR="$(pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
# Same setup-finished marker as the app launchers, so running this check
# first on a new computer leaves a complete setup the app can reuse.
READY_MARKER="$VENV_DIR/.deps-installed"

PY=""
for c in python3 python; do
    if command -v "$c" >/dev/null 2>&1; then PY="$c"; break; fi
done
if [ -z "$PY" ]; then
    echo "Python 3 was not found. Install it from https://python.org/downloads/"
    read -r -p "Press Return to close." _; exit 1
fi

if [ -d "$VENV_DIR/bin" ] && [ ! -f "$VENV_DIR/pyvenv.cfg" ]; then
    echo "Repairing a damaged setup folder..."
    rm -rf "$VENV_DIR"
fi

if [ ! -f "$READY_MARKER" ]; then
    echo "Setting up for the first time (installing dependencies)..."
    echo "This only happens once and can take a minute."
    echo
    if [ ! -f "$VENV_DIR/pyvenv.cfg" ]; then
        "$PY" -m venv "$VENV_DIR" || {
            echo "Could not create the virtual environment. See the error above."
            read -r -p "Press Return to close." _; exit 1; }
    fi
    "$VENV_DIR/bin/python" -m pip --version >/dev/null 2>&1 || \
        "$VENV_DIR/bin/python" -m ensurepip --upgrade
    "$VENV_DIR/bin/python" -m pip install --quiet --upgrade pip
    "$VENV_DIR/bin/python" -m pip install --quiet -r "$SCRIPT_DIR/requirements.txt" || {
        echo "Dependency install failed. See the error above."
        read -r -p "Press Return to close." _; exit 1; }
    echo "installed" > "$READY_MARKER"
fi

# Ensure the Bluetooth library is present even if the venv predates it.
"$VENV_DIR/bin/python" -c "import bleak" >/dev/null 2>&1 || {
    echo "Installing the Bluetooth scanner library..."
    "$VENV_DIR/bin/python" -m pip install --quiet bleak; echo; }

cd "$SCRIPT_DIR/.." || exit 1
"$VENV_DIR/bin/python" -m local_mind_monitor.bluetooth_check

echo
echo "------------------------------------------------------------"
read -r -p "Copy the results above if you need to share them. Press Return to close." _
