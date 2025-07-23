Issues with wkd/ntp behind http_proxy:

- https://github.com/archlinux/archinstall/issues/1852

Packages:

```sh
# keyboard/locale settings
loadkeys dvorak
sudo localectl set-x11-keymap us pc105 dvorak terminate:ctrl_alt_bksp,caps:escape,grp:rwin_toggle

# set reflector countries and generate mirrorlist
sudo perl -pi -e 's/^(# )?--country.*/--country Indonesia,Singapore/' /etc/xdg/reflector/reflector.conf
sudo systemctl enable --now reflector.timer
sudo reflector @/etc/xdg/reflector/reflector.conf

# disable debug packages
sudo perl -pi -e 's/^(OPTIONS=.+) debug(.*)/\1 !debug\2/' /etc/makepkg.conf

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
  lvm2 \
  dmidecode nvme-cli \
  base-devel git git-delta \
  bash-completion \
  bat lesspipe rlwrap neovim nvimpager \
  mtr btop htop wget curl nmap whois drill rsync inetutils jq 7zip \
  nodejs npm \
  zig vlang odin rustup ruby \
  ruby-bundler pnpm \
  tailscale \
  zig vlang odin rustup \
  ruby ruby-bundler \
  mingw-w64-gcc \
  podman slirp4netns \
  postgresql mariadb-clients oracle-instantclient-sqlplus \
  usql iv-cli libvips \
  tor tmux weechat \
  qemu-full qemu-desktop qemu-user-static qemu-user-static-binfmt quickemu \
  libsixel neofetch \
  noto-fonts noto-fonts-emoji noto-fonts-extra ttf-noto-nerd \
  ttf-ubuntu-font-family ttf-ubuntu-nerd ttf-ubuntu-mono-nerd \
  ttf-inconsolata-nerd ttf-inconsolata-lgc-nerd \
  tela-circle-icon-theme-purple \
  adw-gtk-theme \
  sway swaybg swayidle swaylock waybar foot \
  xorg-xlsclients \
  xsel wl-clipboard \
  wofi mako copyq gsimplecal \
  grim slurp pngquant wf-recorder satty \
  ghostty alacritty wezterm kitty \
  gnome-terminal gnome-tweaks vlc \
  firefox google-chrome webcord steam \
  plexamp-appimage \
  unixodbc \
  yt-dlp \

  vulkan-tools \
  libva-utils \
  vdpauinfo \

sudo systemctl enable --now plocate-updatedb.timer
sudo systemctl enable --now cronie.service
```
