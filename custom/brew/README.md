# Homebrew/Brewfile Configuration

This directory contains Brewfiles for installing packages with Homebrew at runtime on ClarityOS.

## What is Homebrew?

Homebrew is a package manager that allows users to install additional software at runtime without modifying the base system image. This aligns with the bootc atomic desktop philosophy where the base image is immutable.

## How It Works

- Brewfiles in this directory are copied to `/usr/share/ublue-os/homebrew/` during build
- Users run `brew bundle --file=/usr/share/ublue-os/homebrew/default.Brewfile` to install packages
- Packages are installed in user space, typically in `~/.linuxbrew/` or `/home/linuxbrew/`

## Included Packages

The default Brewfile includes:
- **Development tools**: git, gh (GitHub CLI), lazygit
- **Modern CLI tools**: ripgrep, fd, fzf, bat, eza, zoxide, starship
- **System monitoring**: htop, btop, ncdu, tldr
- **Container tools**: dive, ctop
- **Fonts**: Nerd Font variants for terminal use

## Adding More Packages

Edit `default.Brewfile` or create additional `.Brewfile` files:

```ruby
# Add a CLI tool
brew "package-name"

# Add a GUI application (cask)
cask "application-name"

# Add a font
cask "font-package-name"
```

## User Installation

After ClarityOS is installed, users can install Homebrew packages:

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages from Brewfile
brew bundle --file=/usr/share/ublue-os/homebrew/default.Brewfile
```

Or using ujust command (if configured):
```bash
ujust brew-bundle
```

## Resources

- [Homebrew Documentation](https://docs.brew.sh/)
- [Homebrew Package Search](https://formulae.brew.sh/)
- [Brewfile Documentation](https://github.com/Homebrew/homebrew-bundle)
