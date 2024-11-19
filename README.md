# Clean Arch Install


Use `archinstall` and install the following additional packages `git neovim networkmanager openssh`


Once everything is installed, boot in and install:

`xf86-video-intel mesa vulkan intel-media-driver intel-hybrid-codec-driver libva-intel-driver-hybrid light`

Install yay: `git clone https://aur.archlinux.org/yay.git` and `cd yay/ && makepkg -si`

Get backlights working: `yay -S light`, `usermod -aG video <YOUR_USERNAME>`

Head to `https://github.com/prasanthrangan/hyprdots` and follow the install.


Once everything is installed, clone this repo, stow nvim and fastfetch

`stow <name>`
