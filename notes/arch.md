Packages:

```sh
# keyboard/locale settings
loadkeys dvorak
sudo localectl set-x11-keymap us pc105 dvorak terminate:ctrl_alt_bksp,caps:escape,grp:rwin_toggle

# set reflector countries and generate mirrorlist
sudo perl -pi -e 's/^--country.*/--country Indonesia,Singapore/ /' /etc/xdg/reflector/reflector.conf
sudo systemctl enable --now reflector.timer
sudo reflector @/etc/xdg/reflector/reflector.conf

# install yay
cd ~/src/
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si

# update base packages
yay -Syuu

# install additional packages
yay -S \
  plocate cronie \
  nvidia-dkms nvidia-utils lib32-nvidia-utils \
  vulkan-tools \
  libva-utils \
  vdpauinfo \
  lvm2 \
  dmidecode nvme-cli \
  base-devel git bash-completion jq rar zip unzip mtr btop htop \
  wget curl nmap whois drill rsync \
  nodejs zig vlang odin rustup ruby \
  ruby-bundler npm pnpm \
  mingw-w64-gcc \
  neovim \
  tailscale podman slirp4netns \
  postgresql mariadb-clients \
  usql iv-cli fv-cli libvips
  tor tmux weechat \
  qemu-full quickemu \
  libsixel neofetch \
  noto-fonts noto-fonts-emoji noto-fonts-extra ttf-noto-nerd \
  ttf-ubuntu-font-family ttf-ubuntu-nerd ttf-ubuntu-mono-nerd \
  ttf-inconsolata-nerd ttf-inconsolata-lgc-nerd \
  tela-circle-icon-theme-purple \
  sway swaybg swayidle swaylock waybar foot \
  xorg-xlsclients \
  xsel wl-clipboard \
  wofi mako copyq \
  grim slurp pngquant wf-recorder \
  gsimplecal \
  gnome-terminal \
  gnome-tweaks \
  vivaldi \
  google-chrome \
  vlc \
  steam \
  webcord \
  wezterm kitty \
  plexamp-appimage

sudo systemctl enable --now plocate-updatedb.timer
sudo systemctl enable --now cronie.service
```
