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

#~~|¨Neofetch¨|~~#
pf "Ajustando neofetch." "warn"
if [ ! -d "$HOME/.config/neofetch" ]; then
  run_cmd_valid "cp -r "./files/config/neofetch" "$HOME/.config/neofetch"" "Configurações do Neofetch"
else
  pf "O diretório ~/.config/neofetch já existe. Seguindo com as configurações!"
fi

#~~|¨Terminal¨|~~#
pf "Iniciando configurações do Alacritty." "warn"
if [ ! -d "$HOME/.config/alacritty" ]; then
  run_cmd_valid "cp -r "./files/config/alacritty" "$HOME/.config/alacritty"" "Configurações do Alacritty"
else
  pf "O diretório ~/.config/alacritty já existe. Seguindo com as configurações!"
fi
pf "Iniciando instalação e configuração do terminal zsh + oh-my-zsh." "warn"
if [ ! -d "$HOME/.config/zsh" ]; then
  run_cmd_valid "cp -r "./files/config/zsh" "$HOME/.config/zsh"" "Configurações do Shell"
  sleep 0.5
  mv "$HOME/.config/zsh/.zshenv" "$HOME/.zshenv"
else
  pf "O diretório ~/.config/zsh já existe. Seguindo com as configurações!"
fi
pf "Instalando Oh My ZSH" "warn"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
if [ -d "$HOME/.oh-my-zsh" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.oh-my-zsh/plugins/"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/"
    mv "$HOME/.oh-my-zsh" "$HOME/.config/zsh"
    rm -r "$HOME/.zshrc"
else
    pf "O diretório ~/.oh-my-zsh/plugins não foi encontrado. Terminando o script." "error"
fi
pf "Instalando spaceship" "warn"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"
pf "Instalação do spaceship concluída!" "warn"

#~~|¨Nvim¨|~~#
# pf "Iniciando configurações do Neo Vim." "warn"
# if [ ! -d "$HOME/.config/nvim" ]; then
#   while true; do
#     read -rep "Você gostaria de usar qual preset do Nvim? (NvChad ou Lunar)" NVIMC
#     if [[ $NVIMC == "NVCHAD" || $NVIMC == "nvchad" ]]; then
#       mkdir "$HOME/.config/nvim"
#       git clone https://github.com/NvChad/starter ~/.config/nvim
#       break
#     elif [[ $NVIMC == "LUNAR" || $NVIMC == "lunar" ]]; then
#       run_cmd_valid "LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)" "Configurações do Lunar Vim"
#       break
#     else
#       pf "Opção inválida. Por favor, escolha um das opções informadas." "error"
#     fi
#   done
# else
#   pf "O diretório ~/.config/nvim já existe. Seguindo com as configurações!"
# fi
# plugin: https://github.com/folke/lazy.nvim
# aprender: https://github.com/folke/lazy.nvim

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

#~~|¨Poetry¨|~~#
pf "Iniciando instalação e configuração do Poetry." "warn"
if command -v poetry &>/dev/null; then
  pipx ensurepath
  pipx install poetry
  pipx inject poetry poetry-plugin-shell
  pf "Poetry instalado e configurado." "success"
fi

#~~|¨Angular CLI¨|~~#
pf "Iniciando instalação e configuração do Angular CLI." "warn"
if command -v ng &>/dev/null; then
  sudo npm install -g @angular/cli
  pf "Angular CLI instalado e configurado." "success"
fi

#~~|¨Docker¨|~~#
pf "Iniciando o docker no systemd." "warn"
if command -v docker &>/dev/null; then
  sudo systemctl enable docker.service
  sudo systemctl start docker.service
  modprobe loop
  pf "Docker iniciado." "success"
fi