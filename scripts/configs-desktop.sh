#!/bin/sh

#~~|¨Head Script¨|~~#
source "./scripts/utils.sh"

#~~|¨Fonts¨|~~#
pf "Iniciando instalação e configuração das fonts e emojis." "warn"
sudo pacman -S --needed --noconfirm noto-fonts-emoji adobe-source-code-pro-fonts adobe-source-serif-fonts adobe-source-sans-fonts ttf-inconsolata
if [ ! -d "$HOME/.config/fontconfig" ]; then
  pf "Criando pasta e arquivo de configuração." "warn"
  mkdir "$HOME/.config/fontconfig"
  echo -e '<?xml version="1.0" encoding="UTF-8"?>\n<!DOCTYPE fontconfig SYSTEM "fonts.dtd">\n<fontconfig>\n<!-- ## serif ## -->\n<alias>\n<family>serif</family>\n<prefer>\n<family>Noto Serif</family>\n<family>emoji</family>\n<family>Liberation Serif</family>\n<family>Nimbus Roman</family>\n<family>DejaVu Serif</family>\n</prefer>\n</alias>\n<!-- ## sans-serif ## -->\n<alias>\n<family>sans-serif</family>\n<prefer>\n<family>Noto Sans</family>\n<family>emoji</family>\n<family>Liberation Sans</family>\n<family>Nimbus Sans</family>\n<family>DejaVu Sans</family>\n</prefer>\n</alias>\n</fontconfig>' > "$HOME/.config/fontconfig/fonts.conf"
  pf "Configuração concluída." "success"
else
  pf "O diretório ~/.config/fontconfig já existe. Seguindo com as configurações!"
fi

#~~|¨Terminal¨|~~#
pf "Iniciando configurações do Alacritty." "warn"
if [ ! -d "$HOME/.config/alacritty" ]; then
  run_cmd_valid "cp -r "./files/config/alacritty" "$HOME/.config/alacritty"" "Configurações do Alacritty"
else
  pf "O diretório ~/.config/alacritty já existe. Seguindo com as configurações!"
fi
pf "Configurando ZSH." "warn"
if [ ! -d "$HOME/.config/zsh" ]; then
  run_cmd_valid "cp -r "./files/config/zsh" "$HOME/.config/zsh"" "Configurações do Shell"
  sleep 0.5
  mv "$HOME/.config/zsh/.zshenv" "$HOME/.zshenv"
  mkdir "$HOME/.config/zsh/plugins"
  sleep 0.5
  git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.config/zsh/plugins/zsh-autosuggestions"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
  git clone https://github.com/zsh-users/zsh-completions "$HOME/.config/zsh/plugins/zsh-completions"
else
  pf "O diretório ~/.config/zsh já existe. Seguindo com as configurações!"
fi
pf "Instalando e configurando Starship" "warn"
sudo pacman -S --needed --noconfirm starship
if [ ! -f "$HOME/.config/starship.toml" ]; then
  run_cmd_valid "cp "./files/config/starship/starship.toml" "$HOME/.config"" "Configurações do Starship"
fi
pf "Terminal configurado com sucesso!" "success"

#~~|¨Git¨|~~#
pf "Vamos começar com as configurações do GitHub. Fique atento!" "warn"
read -rep "Qual seu nome de usuário no github?" RESUSER
if [[ -n "$RESUSER" ]]; then
  run_cmd_valid "git config --global user.name "$RESUSER"" "Configurando nome de usuário"
fi
read -rep "Qual seu email do github?" RESMAIL
if [[ -n "$RESMAIL" ]]; then
  run_cmd_valid "git config --global user.email "$RESMAIL"" "Configurando email"
fi
read -rep "Qual nome padrão você deseja para sua branch inicial?" RESBH
if [[ -n "$RESBH" ]]; then
  run_cmd_valid "git config --global init.defaultBranch "$RESBH"" "Configurando branchs"
fi
if command -v gh &>/dev/null; then
  pf "Você já tem o GitHub CLI instalado. Ao iniciar o sistema com a interface, use o comando 'gh auth login' em seu terminal."
fi

#~~|¨Poetry & UV¨|~~#
pf "Iniciando instalação e configuração do Poetry e UV." "warn"
if command -v poetry &>/dev/null; then
  pipx ensurepath
  pipx install poetry uv
  pipx inject poetry poetry-plugin-shell
  pf "Poetry instalado e configurado." "success"
fi

#~~|¨Angular CLI¨|~~#
pf "Iniciando instalação e configuração do Angular CLI." "warn"
if command -v ng &>/dev/null; then
  sudo npm install -g @angular/cli
  pf "Angular CLI instalado e configurado." "success"
fi

#~~|¨NVM¨|~~#
pf "Iniciando instalação do NVM para versionamento do node." "warn"
if command -v nvm &>/dev/null; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
  \. "$HOME/.nvm/nvm.sh"
  nvm install lts
  pf "NVM instalado e configurado." "success"
fi

#~~|¨Docker¨|~~#
pf "Iniciando o docker no systemd." "warn"
if command -v docker &>/dev/null; then
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
  modprobe loop
  pf "Docker iniciado." "success"
fi
