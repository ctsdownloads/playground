# Build Scripts

This directory contains build scripts that run during the container image build process.

## How It Works

Scripts in this directory are executed in numerical order during the image build:
- `10-build.sh` - Main build script (installs COSMIC, CLI tools, copies custom files)
- `20-*.sh` - Additional scripts (if needed)
- `30-*.sh` - More scripts (if needed)

## Script Naming Convention

Use numbered prefixes to control execution order:
- `10-` Base system packages and core functionality
- `20-` Third-party repositories and additional software
- `30-` Desktop environment modifications
- `40-` System configuration and tweaks

## Main Build Script

The `10-build.sh` script handles:
1. **Custom file copying**: Brewfiles, ujust commands, flatpaks, branding
2. **COSMIC Desktop installation**: From Fedora 43 repositories
3. **CLI tools installation**: Developer and power-user tools
4. **System configuration**: Display manager, systemd services

## Adding Custom Build Steps

### Create a New Build Script

1. Create a new script with a numbered prefix:
   ```bash
   touch build/20-custom-software.sh
   chmod +x build/20-custom-software.sh
   ```

2. Add your custom installation steps:
   ```bash
   #!/usr/bin/bash
   set -eoux pipefail
   
   echo "::group:: Custom Software Installation"
   
   dnf5 install -y your-package-here
   
   echo "::endgroup::"
   ```

### Using COPR Repositories

The `copr-helpers.sh` file provides a safe function for COPR usage:

```bash
source /ctx/build/copr-helpers.sh

# Install from COPR using isolated pattern
copr_install_isolated "owner/repo-name" package1 package2
```

This pattern:
- Enables the COPR repository
- Installs packages
- Disables the COPR repository (isolated pattern)
- Prevents COPR from persisting in the final image

## Best Practices

### Error Handling
All scripts should use:
```bash
set -eoux pipefail
```

This ensures:
- `e` - Exit on error
- `o` - Pipeline fails if any command fails
- `u` - Treat unset variables as errors
- `x` - Print commands as they execute (debugging)

### Grouping Output
Use GitHub Actions-style groups for better log readability:
```bash
echo "::group:: Your Step Name"
# Your commands here
echo "::endgroup::"
```

### Package Installation
- Use `dnf5` for system packages (faster than dnf)
- Group related packages together
- Add comments explaining why packages are needed

### File Operations
- Copy files from `/ctx/` mount (source context)
- Place files in final system locations (`/etc/`, `/usr/share/`, etc.)
- Create directories before copying files

## Directory Structure

```
build/
├── 10-build.sh         # Main build script
├── copr-helpers.sh     # Helper functions for COPR
├── 20-*.sh            # Additional scripts (optional)
└── README.md          # This file
```

## Debugging Build Issues

If a build fails:

1. Check the GitHub Actions logs for the error
2. Look for the last successful `::group::` marker
3. Test locally with:
   ```bash
   just build
   ```
4. Fix the issue in the relevant script
5. Rebuild and test

## Resources

- [Universal Blue Documentation](https://universal-blue.org/)
- [bootc Documentation](https://containers.github.io/bootc/)
- [DNF5 Documentation](https://dnf5.readthedocs.io/)
- [Fedora Package Database](https://packages.fedoraproject.org/)
