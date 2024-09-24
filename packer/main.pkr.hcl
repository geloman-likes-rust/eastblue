packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.4"
      source  = "github.com/digitalocean/digitalocean"
    }
  }
}

source "digitalocean" "eastblue" {
  image         = "ubuntu-24-04-x64"
  snapshot_name = "eastblue-linux"
  size          = "s-1vcpu-1gb"
  region        = "sgp1"
  ssh_username  = "root"
}

build {
  sources = ["source.digitalocean.eastblue"]
  provisioner "shell" {
    inline = [
      "apt update -y && apt upgrade -y",
      "apt install -y zsh neovim eza fzf ripgrep fd-find bat git-delta gcc tar unzip curl wget neofetch",
      "useradd --create-home --groups sudo --shell /usr/bin/zsh geloman",
      "mkdir -p /home/geloman/.config /home/geloman/.personal /home/geloman/.development",
      "git clone --depth 1 https://github.com/geloman-likes-rust/dotfiles /home/geloman/.dotfiles",
      "git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git /home/geloman/.oh-my-zsh",
      "git clone --depth 1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm",
      "ln -s /home/geloman/.dotfiles/zsh/.zshrc /home/geloman/.zshrc",
      "ln -s /home/geloman/.dotfiles/nvim /home/geloman/.config/",
      "ln -s /home/geloman/.dotfiles/tmux/.tmux.conf /home/geloman/.tmux.conf",
      "su geloman -c \"nvim --headless '+Lazy! restore' +qa\"",
      "chown -R geloman:geloman /home/geloman"
    ]
  }
}
