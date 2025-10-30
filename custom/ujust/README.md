# ujust Commands for ClarityOS

This directory contains `.just` files that define custom user commands accessible via `ujust`.

## What is ujust?

`ujust` is a wrapper around the `just` command runner that allows system administrators to provide convenient shortcuts for common tasks. It's similar to custom bash functions but with better organization and discoverability.

## How It Works

- `.just` files in this directory are concatenated during build
- They're combined into `/usr/share/ublue-os/just/60-custom.just`
- Users run commands with: `ujust command-name`
- List available commands with: `ujust`

## Included Commands

ClarityOS includes these custom commands:

### System Management
- `ujust update` - Update the system with bootc
- `ujust switch-to-latest` - Switch to latest ClarityOS build
- `ujust cleanup` - Clean up old bootc deployments
- `ujust regenerate-initramfs` - Regenerate initramfs if needed
- `ujust info` - Show system information

### Package Management
- `ujust brew-bundle` - Install Homebrew packages from Brewfile

## Adding Custom Commands

Create or edit `.just` files in this directory:

```just
# My custom command
my-command:
    #!/usr/bin/bash
    echo "Running my custom command"
    # Your commands here
```

### Command Syntax

```just
command-name PARAM1 PARAM2="default":
    #!/usr/bin/bash
    echo "Parameter 1: {{ PARAM1 }}"
    echo "Parameter 2: {{ PARAM2 }}"
```

### Best Practices

1. **Use descriptive names**: `update-system` not `us`
2. **Add help text**: Use comments to explain what commands do
3. **Group related commands**: Put similar commands in the same file
4. **Error handling**: Check for command existence before running
5. **User feedback**: Echo what the command is doing

## Example Commands

### Simple Command
```just
hello:
    echo "Hello from ClarityOS!"
```

### Command with Parameters
```just
install-app NAME:
    flatpak install -y flathub {{ NAME }}
```

### Command with Confirmation
```just
dangerous-operation:
    #!/usr/bin/bash
    read -p "Are you sure? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Proceeding..."
    fi
```

## Resources

- [just Documentation](https://github.com/casey/just)
- [Universal Blue ujust Guide](https://universal-blue.org/guide/just/)
- [Justfile Syntax](https://just.systems/man/en/)
