#!/data/data/com.termux/files/usr/bin/bash
termux-setup-storage
export DEBIAN_FRONTEND=noninteractive
apt-get update -y -q 2>&1 >/dev/null
echo "[1/15] Repositorios atualizados"
apt-get upgrade -y -q -o Dpkg::Options::="--force-confnew" 2>&1 >/dev/null
echo "[2/15] Sistema atualizado"
PACKAGES="x11-repo tur-repo termux-x11-nightly xorg-xrandr xfce4 xfce4-terminal mesa-zink vulkan-loader-android virglrenderer-mesa-zink virglrenderer-android pulseaudio pulseaudio-utils dbus chromium hangover-wine hangover-wowbox64"
STEP=2
for pkg in $PACKAGES; do STEP=$((STEP + 1)); echo -n "[$STEP/15] Instalando: $pkg ... "; apt-get install -y -q -o Dpkg::Options::="--force-confnew" "$pkg" 2>&1 >/dev/null; echo "OK"; done
ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine 2>/dev/null
chmod +x /data/data/com.termux/files/usr/bin/wine 2>/dev/null
mkdir -p ~/.wine
mkdir -p ~/.config/pulse
mkdir -p ~/.config/alsa
cat > ~/.config/alsa/asoundrc << 'EOFF'
pcm.pulse {
    type pulse
}
ctl.pulse {
    type pulse
}
pcm.!default {
    type pulse
}
ctl.!default {
    type pulse
}
EOFF
cat > ~/.config/pulse/default.pa << 'EOFF'
load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1
load-module module-always-sink
load-module module-suspender
load-module module-aaudio-sink
set-default-sink AAudio_sink
EOFF
cat > ~/start.sh << 'EOFF'
#!/data/data/com.termux/files/usr/bin/bash
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
termux-x11 :0 -ac &> /dev/null &
sleep 3
export DISPLAY=:0
startxfce4 > /dev/null 2>&1 &
sleep 5
pactl set-default-sink AAudio_sink 2>/dev/null
am start --user 0 -n com.termux.x11/.MainActivity 2>/dev/null
EOFF
chmod +x ~/start.sh
cat > ~/stop.sh << 'EOFF'
#!/data/data/com.termux/files/usr/bin/bash
xfce4-session-logout --logout 2>/dev/null
sleep 2
pkill -TERM -f "startxfce4" 2>/dev/null
pkill -TERM -f "termux.x11" 2>/dev/null
pulseaudio --kill 2>/dev/null
killall dbus-daemon 2>/dev/null
termux-wake-unlock 2>/dev/null
EOFF
chmod +x ~/stop.sh
mkdir -p ~/bin
cat > ~/bin/acelerar << 'EOFF'
#!/data/data/com.termux/files/usr/bin/bash
GALLIUM_DRIVER=virpipe "$@"
EOFF
chmod +x ~/bin/acelerar
cat > ~/bin/wine << 'EOFF'
#!/data/data/com.termux/files/usr/bin/bash
GALLIUM_DRIVER=virpipe /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine "$@"
EOFF
chmod +x ~/bin/wine
sed -i '/alias xfce=/d' ~/.bashrc 2>/dev/null
sed -i '/alias xfce-stop=/d' ~/.bashrc 2>/dev/null
if ! grep -q "hangover-wine/bin" ~/.bashrc 2>/dev/null; then
echo -e "\nexport PATH=\$PATH:/data/data/com.termux/files/usr/opt/hangover-wine/bin\nexport WINEPREFIX=~/.wine" >> ~/.bashrc
fi
if ! grep -q "PULSE_SERVER=127.0.0.1" ~/.bashrc 2>/dev/null; then
echo -e "\nexport PULSE_SERVER=127.0.0.1\nexport PULSE_RUNTIME_PATH=/data/data/com.termux/files/usr/var/run/pulse\nexport ALSA_CONFIG_PATH=/data/data/com.termux/files/home/.config/alsa/asoundrc" >> ~/.bashrc
fi
cd
clear
echo "========================================="
echo "INSTALACAO CONCLUIDA"
echo "========================================="
