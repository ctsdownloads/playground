# ClarityOS Branding

This directory contains custom branding files that will be copied to the system during build.

## Structure

- `usr/etc/` - System configuration files (copied to `/etc/`)
- `usr/share/` - Shared data files (copied to `/usr/share/`)

## Example Contents

### usr/etc/
System configuration overrides:
- Profile configurations
- Default application settings
- System-wide preferences

### usr/share/
Shared resources:
- Icons and themes
- Wallpapers
- Application data
- Documentation

## Adding Custom Branding

1. Create appropriate directory structure:
   ```bash
   mkdir -p usr/share/wallpapers/clarityos
   mkdir -p usr/share/icons/clarityos
   ```

2. Add your files:
   ```bash
   cp my-wallpaper.png usr/share/wallpapers/clarityos/
   cp my-logo.svg usr/share/icons/clarityos/
   ```

3. Files are automatically copied during build by `10-build.sh`

## Examples

### Custom Wallpaper
```bash
usr/share/wallpapers/clarityos/
└── default.png
```

### Custom Icon Theme
```bash
usr/share/icons/clarity-icons/
├── index.theme
└── scalable/
    ├── apps/
    └── places/
```

### System Configuration
```bash
usr/etc/profile.d/
└── clarity-defaults.sh
```

## Notes

- Keep branding files lightweight
- Use appropriate file formats (SVG for icons, optimized PNG/JPG for images)
- Follow XDG Base Directory specifications
- Test changes with `just build` before committing
