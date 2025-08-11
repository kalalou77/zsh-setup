et -euo pipefail

GREEN='\033[0;32m'; NC='\033[0m'

echo -e "${GREEN}--- Updating system packages ---${NC}"
sudo apt update -y
sudo apt install -y zsh curl git

# Optional: powerline fonts (for fallback); MesloLGS NF Nerd Font is recommended for P10k
sudo apt install -y fonts-powerline || true

echo -e "${GREEN}--- Setting Zsh as default shell ---${NC}"
if [ "${SUDO_USER-}" ]; then
	  # Script was run with sudo → change the calling user's shell
	    sudo chsh -s "$(command -v zsh)" "$SUDO_USER"
    else
	      chsh -s "$(command -v zsh)"
fi

echo -e "${GREEN}--- Installing Oh My Zsh ---${NC}"
export RUNZSH=no
export CHSH=no
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo -e "${GREEN}--- Installing Powerlevel10k theme ---${NC}"
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
	  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

echo -e "${GREEN}--- Installing useful plugins ---${NC}"
# zsh-autosuggestions
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
	  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
	  # zsh-syntax-highlighting (must be last in plugin list)
	  [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
		    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
	  # Note: Oh My Zsh already ships a `z` plugin → no need to clone it separately

	  echo -e "${GREEN}--- Configuring .zshrc ---${NC}"
	  ZSHRC="$HOME/.zshrc"
	  if [ ! -f "$ZSHRC" ]; then
		    cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$ZSHRC"
	  fi

	  # Set theme
	  if grep -q '^ZSH_THEME=' "$ZSHRC"; then
		    sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC"
	    else
		      echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> "$ZSHRC"
	  fi

	  # Set plugins
	  if grep -q '^plugins=' "$ZSHRC"; then
		    sed -i 's|^plugins=.*|plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)|' "$ZSHRC"
	    else
		      echo 'plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)' >> "$ZSHRC"
	  fi

	  echo -e "${GREEN}--- Done! Restart your terminal or run: exec zsh ---${NC}"
	  echo -e "${GREEN}Tip: Install MesloLGS NF (Nerd Font) for proper Powerlevel10k icons.${NC}"

