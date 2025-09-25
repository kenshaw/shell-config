# Arch Notes

```sh
# keyboard/locale settings
loadkeys dvorak
sudo localectl set-x11-keymap us pc105 dvorak terminate:ctrl_alt_bksp,caps:escape,grp:rwin_toggle

# disable [community*] repos in pacman.conf
sudo sed -i '/^\[community/,+1s/^/#/' /etc/pacman.conf

# update keyring
sudo pacman -Syy archlinux-keyring

# if there is an issue with the above
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate archlinux

# full upgrade
sudo pacman -Syyuu
sudo reboot

# base development packages (perl, git, ...)
sudo pacman -Sy base-devel git nano

# install reflector, set countries, generate mirrorlist
sudo pacman -Sy reflector
sudo perl -pi -e 's/^(# )?--country.*/--country Indonesia,Singapore/' /etc/xdg/reflector/reflector.conf
sudo systemctl enable --now reflector.timer
sudo reflector @/etc/xdg/reflector/reflector.conf

# disable debug packages
sudo perl -pi -e 's/^(OPTIONS=.+) debug(.*)/\1 !debug\2/' /etc/makepkg.conf

# install yay
mkdir ~/src
cd ~/src/ && git clone https://aur.archlinux.org/yay.git
cd ~/src/yay && makepkg -si

# switch to linux-lts (systemd)
yay -S linux-lts linux-lts-headers
sudo perl -pi -e 's%/(vmlinuz|initramfs)-linux(\.img)?$%/\1-linux-lts\2%' /boot/loader/entries/arch.conf
sudo systemctl reboot
yay -Rs linux linux-headers

# switch to linux (grub)
yay -S linux-lts linux-lts-headers
yay -Rs linux linux-headers
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl reboot

# keep HOME + SSH_AUTH_SOCK variables during sudo
echo 'Defaults env_keep+="SSH_AUTH_SOCK HOME"' | sudo tee -a /etc/sudoers.d/env

# add user
sudo useradd -m -G wheel,adm -s /bin/bash <username>

# add ssh key
cat $HOME/.ssh/id_ed25519.pub |wl-copy
echo "$KEY" |tee -a ~/.ssh/authorized_keys

# usual tools
yay -S  \
  bash-completion git-delta \
  lvm2 dmidecode nvme-cli \
  mtr btop htop wget curl nmap whois drill rsync inetutils jq 7zip \
  bat less lesspipe rlwrap \
  neovim nvimpager nodejs npm

sudo ln -s ./nvim /usr/bin/vi

# system services
yay -S \
  plocate cronie nftables
sudo systemctl enable --now \
  plocate-updatedb.timer \
  cronie.service \
  nftables.service

# other
yay -S \
  qemu-full qemu-desktop qemu-user-static qemu-user-static-binfmt quickemu-git \
  mingw-w64-gcc \
  podman slirp4netns \
  tailscale \
  iv-cli libvips \
  tor tmux weechat \
  libsixel neofetch \
  yt-dlp

# database
yay -S \
  usql \
  postgresql mariadb-clients oracle-instantclient-sqlplus \
  unixodbc

# misc development
yay -S \
  zig vlang odin rustup ruby \
  ruby-bundler pnpm

# default rust toolchain
rustup default stable

# pam ssh auth (needs rust/cargo -- see above)
yay -S \
  pam-ssh-agent

# nvidia
yay -S \
  nvidia-dkms nvidia-utils lib32-nvidia-utils

# fonts
yay -S \
  noto-fonts \
  noto-fonts-emoji \
  noto-fonts-extra \
  ttf-cascadia-code-nerd \
  ttf-cascadia-mono-nerd \
  ttf-dejavu \
  ttf-envy-code-r \
  ttf-ibm-plex \
  ttf-ibmplex-mono-nerd \
  ttf-inconsolata-lgc-nerd \
  ttf-inconsolata-nerd \
  ttf-jetbrains-mono \
  ttf-liberation \
  ttf-nerd-fonts-symbols-common \
  ttf-nerd-fonts-symbols-mono \
  ttf-noto-nerd \
  ttf-roboto \
  ttf-ubuntu-font-family \
  ttf-ubuntu-mono-nerd \
  ttf-ubuntu-nerd \
  adobe-source-code-pro-fonts \
  cantarell-fonts

# desktop
yay -S \
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
  plexamp-appimage

# vulkan
yay -S \
  vulkan-tools \
  libva-utils \
  vdpauinfo

# misc cloud stuff
yay -S \
  google-cloud-cli-lite \
  google-cloud-cli-gke-gcloud-auth-plugin \
  terraform \
  kubectl \
  helm \
  sops \
  age

# basic docker compose
yay -S \
  docker \
  docker-compose
sudo systemctl enable --now \
  docker.service \
  containerd.service
sudo usermod -aG docker $USER
newgrp docker
```

- [Issues with wkd/ntp behind http_proxy][wkd-ntp-proxy-issues]
- [GCP/GCE notes][gcp-gce-notes]

[wkd-ntp-proxy-issues]: https://github.com/archlinux/archinstall/issues/1852
[gcp-gce-notes]: https://gist.github.com/mukaschultze/1167a104ca245a57508e4df66d6c686a
