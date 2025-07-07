#!/bin/bash

set -e

# Couleurs pour lisibilité
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}--- Mise à jour du système ---${NC}"
sudo apt update && sudo apt install -y zsh curl git fonts-powerline

echo -e "${GREEN}--- Définir Zsh comme shell par défaut ---${NC}"
chsh -s $(which zsh)

echo -e "${GREEN}--- Installation de Oh My Zsh ---${NC}"
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo -e "${GREEN}--- Installation du thème Powerlevel10k ---${NC}"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo -e "${GREEN}--- Installation des plugins utiles ---${NC}"
# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# syntax highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# z plugin
git clone https://github.com/rupa/z.git $ZSH_CUSTOM/plugins/z

echo -e "${GREEN}--- Configuration de .zshrc ---${NC}"
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/^plugins=.*/plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

echo -e "${GREEN}--- Configuration terminée. Relance ton terminal ou exécute zsh manuellement ---${NC}"

