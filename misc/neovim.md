```sh

echo "deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu $(lsb_release -c -s) main" |sudo tee -a /etc/apt/sources.list.d/neovim.list

sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --set vi /usr/bin/nvim
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --set vim /usr/bin/nvim
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
sudo update-alternatives --set editor /usr/bin/nvim
```
