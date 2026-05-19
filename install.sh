#!/data/data/com.termux/files/usr/bin/bash
clear
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ██████╗ ██╗  ██╗███████╗ █████╗ ██╗     ███████╗██╗   ██╗      ║"
echo "║ ██╔═══██╗██║ ██╔╝██╔════╝██╔══██╗██║     ██╔════╝██║   ██║     ║"
echo "║ ██║   ██║█████╔╝ ███████╗███████║██║     █████╗  ██║   ██║      ║"
echo "║ ██║   ██║██╔═██╗ ╚════██║██╔══██║██║     ██╔══╝  ╚██╗ ██╔╝      ║"
echo "║ ╚██████╔╝██║  ██╗███████║██║  ██║███████╗███████╗ ╚████╔╝     ║"
echo "║  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝  ╚═══╝       ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
export DEBIAN_FRONTEND=noninteractive
apt-get update -y -q 2>&1 >/dev/null
echo "[1/14] Repositorios atualizados"
apt-get upgrade -y -q -o Dpkg::Options::="--force-confnew" 2>&1 >/dev/null
echo "[2/14] Sistema atualizado"
PACKAGES="x11-repo tur-repo termux-x11-nightly xorg-xrandr xfce4 xfce4-terminal mesa-zink virglrenderer-mesa-zink virglrenderer-android pulseaudio dbus chromium hangover-wine"
STEP=2
for pkg in $PACKAGES; do STEP=$((STEP + 1)); echo -n "[$STEP/14] Instalando: $pkg ... "; apt-get install -y -q -o Dpkg::Options::="--force-confnew" "$pkg" 2>&1 >/dev/null; echo "OK"; done
ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine 2>/dev/null
chmod +x /data/data/com.termux/files/usr/bin/wine 2>/dev/null
mkdir -p ~/.wine ~/.config/pulse ~/.config/alsa
cat > ~/.config/alsa/asoundrc << 'EOFF'
pcm.pulse { type pulse }
ctl.pulse { type pulse }
pcm.!default { type pulse }
ctl.!default { type pulse }
EOFF
cat > ~/.config/pulse/default.pa << 'EOFF'
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
load-module module-always-sink
load-module module-suspender
load-module module-aaudio-sink
set-default-sink AAudio_sink
EOFF
cat > ~/start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
exec 2>/dev/null
exec 1>/dev/null
termux-wake-lock
pkill -f "termux.x11" 2>/dev/null
killall dbus-daemon 2>/dev/null
pulseaudio --kill 2>/dev/null
sleep 2
pulseaudio --start --exit-idle-time=-1 --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --load="module-always-sink" --load="module-aaudio-sink" 2>/dev/null
sleep 2
export PULSE_SERVER=127.0.0.1
export PULSE_RUNTIME_PATH=/data/data/com.termux/files/usr/var/run/pulse
export ALSA_CONFIG_PATH=/data/data/com.termux/files/home/.config/alsa/asoundrc
dbus-daemon --session --fork --address=unix:path=$PREFIX/var/run/dbus/session_bus_socket 2>/dev/null
export DBUS_SESSION_BUS_ADDRESS=unix:path=$PREFIX/var/run/dbus/session_bus_socket
termux-x11 :0 -ac 2>&1 >/dev/null &
sleep 3
export DISPLAY=:0
startxfce4 2>&1 >/dev/null &
sleep 8
pactl set-default-sink AAudio_sink 2>/dev/null
am start --user 0 -n com.termux.x11/.MainActivity 2>/dev/null
EOF
chmod +x ~/start.sh
cat > ~/stop.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
xfce4-session-logout --logout 2>/dev/null
sleep 2
pkill -TERM -f "startxfce4" 2>/dev/null
pkill -TERM -f "termux.x11" 2>/dev/null
pulseaudio --kill 2>/dev/null
killall dbus-daemon 2>/dev/null
termux-wake-unlock 2>/dev/null
EOF
chmod +x ~/stop.sh
mkdir -p ~/bin
cat > ~/bin/acelerar << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
GALLIUM_DRIVER=virpipe "$@"
EOF
chmod +x ~/bin/acelerar
cat > ~/bin/wine << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
GALLIUM_DRIVER=virpipe /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine "$@"
EOF
chmod +x ~/bin/wine
sed -i '/alias xfce=/d' ~/.bashrc 2>/dev/null
sed -i '/alias xfce-stop=/d' ~/.bashrc 2>/dev/null
sed -i '/acelerar/d' ~/.bashrc 2>/dev/null
sed -i '/PULSE_SERVER/d' ~/.bashrc 2>/dev/null
sed -i '/WINEPREFIX/d' ~/.bashrc 2>/dev/null
sed -i '/cleanup_on_exit/d' ~/.bashrc 2>/dev/null
sed -i '/trap cleanup_on_exit/d' ~/.bashrc 2>/dev/null
cat > ~/.bashrc << 'EOF'
export PATH=$PATH:/data/data/com.termux/files/usr/opt/hangover-wine/bin
export WINEPREFIX=~/.wine
export PULSE_SERVER=127.0.0.1
export PULSE_RUNTIME_PATH=/data/data/com.termux/files/usr/var/run/pulse
export ALSA_CONFIG_PATH=/data/data/com.termux/files/home/.config/alsa/asoundrc

cleanup_on_exit() {
    if [[ -n "$DISPLAY" ]] && pgrep -f "startxfce4" >/dev/null 2>&1; then
        ~/stop.sh 2>/dev/null || true
    fi
}
trap cleanup_on_exit EXIT
trap cleanup_on_exit TERM HUP INT
EOF
source ~/.bashrc
termux-setup-storage
cd
clear
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                                         ║"
echo "║                            INSTALAÇÃO CONCLUÍDA!                        ║"
echo "║                                                                         ║"
echo "║                            cd && ./start.sh                             ║"
echo "║                                                                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
