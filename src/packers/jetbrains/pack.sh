#!/bin/bash

[ -d ~/.config/JetBrains ] && mkdir -p "$DIR_STORE/.config" && cp -r ~/.config/JetBrains "$DIR_STORE/.config"

touch "$DIR_STORE/installed"

which rider >/dev/null && echo "RD" >> "$DIR_STORE/installed" || true
which datagrip >/dev/null && echo "DG" >> "$DIR_STORE/installed" || true
which clion >/dev/null && echo "CL" >> "$DIR_STORE/installed" || true
which webstorm >/dev/null && echo "WS" >> "$DIR_STORE/installed" || true
which rubymine >/dev/null && echo "RM" >> "$DIR_STORE/installed" || true
which phpstorm >/dev/null && echo "PS" >> "$DIR_STORE/installed" || true
