#!/data/data/com.termux/files/usr/bin/bash
termux-setup-storage
export DEBIAN_FRONTEND=noninteractive
instalar_com_progresso() { local pkg="$1"; local step="$2"; local total="$3"; echo -n "[$step/$total] Instalando: $pkg ... "; apt-get install -y -q -o Dpkg::Options::="--force-confnew" "$pkg" 2>&1 | while read line; do if echo "$line" | grep -q "Get:[0-9]* http"; then local perc=$(echo "$line" | grep -o '[0-9]*%' | head -1); if [ -n "$perc" ]; then echo -ne "\r[$step/$total] Instalando: $pkg ... $perc   "; fi; fi; done; wait $!; echo -e "\r[$step/$total] Instalando: $pkg ... OK   "; }
clear
echo "========================================="
echo "              OKSALEV"
echo "========================================="
echo ""
apt-get update -y -q 2>&1 >/dev/null
echo "[1/16] Repositorios atualizados"
apt-get upgrade -y -q -o Dpkg::Options::="--force-confnew" 2>&1 >/dev/null
echo "[2/16] Sistema atualizado"
PACKAGES="x11-repo tur-repo termux-x11-nightly xorg-xrandr xfce4 xfce4-terminal mesa-zink vulkan-loader-android virglrenderer-mesa-zink virglrenderer-android pulseaudio pulseaudio-utils dbus chromium hangover-wine hangover-wowbox64 sox"
STEP=2
for pkg in $PACKAGES; do STEP=$((STEP + 1)); instalar_com_progresso "$pkg" "$STEP" 16; done
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
startxfce4 &> /dev/null &
sleep 8
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
mkdir -p ~/Desktop
cat > ~/Desktop/terminal-acelerado.desktop << 'EOFF'
[Desktop Entry]
Name=Terminal Acelerado
Exec=env GALLIUM_DRIVER=virpipe xfce4-terminal
Type=Application
Icon=utilities-terminal
Categories=System;
EOFF
chmod +x ~/Desktop/terminal-acelerado.desktop 2>/dev/null
cat > ~/Desktop/testar-audio << 'EOFF'
#!/data/data/com.termux/files/usr/bin/bash
play -n synth 2 sin 880 vol 0.5 2>/dev/null
EOFF
chmod +x ~/Desktop/testar-audio
cat > ~/Desktop/audio-info << 'EOFF'
#!/data/data/com.termux/files/usr/bin/bash
pactl list short sinks
echo ""
pactl info | grep "Default Sink"
EOFF
chmod +x ~/Desktop/audio-info
sed -i '/alias xfce=/d' ~/.bashrc 2>/dev/null
sed -i '/alias xfce-stop=/d' ~/.bashrc 2>/dev/null
sed -i 's|~/start.sh &>/dev/null &||g' ~/.bashrc 2>/dev/null
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
