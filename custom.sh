#!/bin/bash

# Verificar si es root
if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root. Usa: sudo ./custom.sh"
    exit 1
fi

# Variables
USER_HOME="/home/$SUDO_USER"
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"
FASTFETCH_CONFIG_DIR="$USER_HOME/.config/fastfetch"
FASTFETCH_LOGO_PATH="$USER_HOME/Custom/one_piece_logo.png"
ZSHRC="$USER_HOME/.zshrc"

echo "🔄 Actualizando sistema..."
apt update && apt upgrade -y

echo "📦 Instalando zsh, fish, fastfetch, git, curl y dconf-cli..."
apt install -y zsh fish fastfetch git curl dconf-cli

echo "💡 Instalando Oh My Zsh si no existe..."
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    sudo -u "$SUDO_USER" sh -c \
    'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'
fi

echo "🔌 Instalando plugins para zsh..."
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
    sudo -u "$SUDO_USER" git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
    sudo -u "$SUDO_USER" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
[ -d "$ZSH_CUSTOM/themes/powerlevel10k" ] || \
    sudo -u "$SUDO_USER" git clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

echo "🛠️ Configurando .zshrc..."
# Cambiar tema y plugins
sudo -u "$SUDO_USER" sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
sudo -u "$SUDO_USER" sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' "$ZSHRC"

# Agregar fastfetch sin conflicto con p10k
if ! grep -q "FASTFETCH_SESSION_SHOWN" "$ZSHRC"; then
    echo -e "\n# Mostrar fastfetch con config personalizada una vez por sesión" | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
    echo 'if [[ $- == *i* ]]; then' | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
    echo '  if [[ -z "$FASTFETCH_SESSION_SHOWN" ]]; then' | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
    echo '    command fastfetch --load-config ~/.config/fastfetch/config.jsonc' | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
    echo '    export FASTFETCH_SESSION_SHOWN=1' | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
    echo '  fi' | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
    echo 'fi' | sudo -u "$SUDO_USER" tee -a "$ZSHRC"
fi

echo "📂 Creando configuración personalizada de Fastfetch..."
sudo -u "$SUDO_USER" mkdir -p "$FASTFETCH_CONFIG_DIR"
sudo -u "$SUDO_USER" tee "$FASTFETCH_CONFIG_DIR/config.jsonc" > /dev/null <<EOF
{
  "logo": {
    "type": "kitty",
    "source": "$FASTFETCH_LOGO_PATH",
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

echo "🐚 Estableciendo zsh como shell predeterminado..."
chsh -s "$(which zsh)" "$SUDO_USER"

echo -e "\n✅ ¡Listo! Reinicia tu terminal o ejecuta 'zsh' para ver Fastfetch con tu configuración personalizada."
