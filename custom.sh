#!/bin/bash

# Requiere privilegios de sudo
if [[ $EUID -ne 0 ]]; then
   echo "Por favor, ejecuta como root: sudo $0"
   exit 1
fi

# Variables
USER_HOME="/home/$SUDO_USER"
FISH_CONFIG_DIR="$USER_HOME/.config/fish"
FASTFETCH_CONFIG_DIR="$USER_HOME/.config/fastfetch"
LOGO_PATH="$USER_HOME/Custom/one_piece_logo.png"

# 1. Instalar Fish Shell
echo "[+] Instalando Fish..."
apt update && apt install -y fish curl git

# 2. Instalar Fisher (gestor de plugins para Fish)
echo "[+] Instalando Fisher..."
sudo -u $SUDO_USER fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

# 3. Instalar plugins recomendados
echo "[+] Instalando plugins para Fish..."
sudo -u $SUDO_USER fish -c "fisher install IlanCosman/tide"
sudo -u $SUDO_USER fish -c "fisher install PatrickF1/fish-syntax-highlighting"
sudo -u $SUDO_USER fish -c "fisher install PatrickF1/fzf.fish"

# 4. Instalar Fastfetch
echo "[+] Instalando Fastfetch..."
apt install -y fastfetch

# 5. Crear carpeta de configuración para Fastfetch
echo "[+] Configurando Fastfetch..."
mkdir -p "$FASTFETCH_CONFIG_DIR"
cat <<EOF > "$FASTFETCH_CONFIG_DIR/config.jsonc"
{
  "logo": {
    "type": "kitty",
    "source": "$LOGO_PATH",
    "width": 23,
    "height": 19
  },
  "modules": [
    {
      "type": "custom",
      "key": "{#90}╭ Keys ───────╮",
      "format": "{#90}╭ Values ────────────────────────────────────────────────────╮"
    },
    {
      "type": "title",
      "key": "{#90}│ {#92}User        {#90}│",
      "format": "{user-name}  {#2}[{home-dir}]"
    },
    {
      "type": "host",
      "key": "{#90}│ {#93}Machine     {#90}│",
      "format": "{name}  {#2}{version}"
    },
    {
      "type": "os",
      "key": "{#90}│ {#93}OS          {#90}│",
      "format": "{name}  {#2}[v{version}]"
    },
    {
      "type": "kernel",
      "key": "{#90}│ {#93}Kernel      {#90}│",
      "format": "{sysname}  {#2}[v{release}]"
    },
    {
      "type": "uptime",
      "key": "{#90}│ {#93}Uptime      {#90}│",
      "format": "{?days}{days}d {?}{hours}h {minutes}m"
    },
    {
      "type": "cpu",
      "key": "{#90}│ {#91}CPU         {#90}│",
      "format": "{name}"
    },
    {
      "type": "gpu",
      "key": "{#90}│ {#91}GPU         {#90}│",
      "format": "{name}"
    },
    {
      "type": "memory",
      "key": "{#90}│ {#91}Memory      {#90}│",
      "format": "{used} / {total} ({percentage})"
    },
    {
      "type": "disk",
      "key": "{#90}│ {#91}Disk        {#90}│",
      "format": "{size-used} / {size-total} ({size-percentage})"
    },
    {
      "type": "localip",
      "key": "{#90}│ {#94}Local IPv4  {#90}│",
      "showIpv4": true,
      "showIpv6": false,
      "showPrefixLen": true,
      "format": "{ifname}: {ipv4}"
    },
    {
      "type": "publicip",
      "key": "{#90}│ {#94}Public IPv4 {#90}│",
      "ipv6": false,
      "format": "{ip}"
    },
    {
      "type": "custom",
      "key": "{#90}╰─────────────╯",
      "format": "{#90}╰────────────────────────────────────────────────────────────╯"
    },
    "break",
    {
      "type": "custom",
      "key": " ",
      "format": "{#90}╭ Colors ───────────────────────────────────╮"
    },
    {
      "type": "custom",
      "format": "{#90}│ {#40}    {#41}    {#42}    {#43}    {#44}    {#45}    {#46}    {#47}   {#90}│"
    },
    {
      "type": "custom",
      "format": "{#90}│ {#100}    {#101}    {#102}    {#103}    {#104}    {#105}    {#106}    {#107}   {#90}│"
    },
    {
      "type": "custom",
      "format": "{#90}╰───────────────────────────────────────────╯"
    }
  ]
}
EOF

# 6. Mostrar Fastfetch automáticamente en Fish
echo "[+] Configurando fish para mostrar fastfetch..."
mkdir -p "$FISH_CONFIG_DIR"
echo "fastfetch" >> "$FISH_CONFIG_DIR/config.fish"

# 7. Dar propiedad de los archivos al usuario real
chown -R $SUDO_USER:$SUDO_USER "$FISH_CONFIG_DIR"
chown -R $SUDO_USER:$SUDO_USER "$FASTFETCH_CONFIG_DIR"

echo "[✔] Todo listo. Abre una nueva terminal Fish para ver Fastfetch con el logo de One Piece."
