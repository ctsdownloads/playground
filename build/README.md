# Build Scripts

This directory contains build-time scripts that customize the ClarityOS image during container build.

## Script Execution Order

Scripts are executed in numerical order:

1. **10-build.sh** - Base system setup
   - Copies custom files (flatpaks, branding, ujust commands)
   - Installs essential CLI tools
   - Configures system services

2. **20-cosmic-desktop.sh** - COSMIC Desktop installation
   - Installs COSMIC Desktop from Fedora 43 repos (or COPR as fallback)
   - Configures display manager
   - Installs additional desktop utilities

## Helper Functions

**copr-helpers.sh** provides safe COPR repository management:

- `copr_install_isolated()` - Install packages from COPR without persisting the repository

## Adding New Scripts

To add customizations:

1. Create a new script with a numeric prefix (e.g., `30-custom.sh`)
2. Make it executable: `chmod +x build/30-custom.sh`
3. Follow the pattern:
   ```bash
   #!/usr/bin/bash
   set -eoux pipefail
   
   echo "::group:: Your Group Name"
   # Your commands here
   echo "::endgroup::"
   ```
4. Update the Containerfile to run your script

## Best Practices

- Use `set -eoux pipefail` for strict error handling
- Group related operations with `echo "::group::"` and `echo "::endgroup::"`
- Test scripts with shellcheck: `shellcheck build/*.sh`
- Use COPR helpers for third-party repositories
- Document what each script does
