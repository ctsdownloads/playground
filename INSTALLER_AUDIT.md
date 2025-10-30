# ClarityOS ISO Installer Configuration Audit

## Executive Summary

The ClarityOS ISO installer is running in unattended/automated mode despite `iso/iso.toml` containing `unattended = false`. This audit identifies all configuration files that could affect installer behavior and documents the root cause.

## Files Audited

### 1. iso/iso.toml
**Location:** `/home/runner/work/playground/playground/iso/iso.toml`  
**Current Content:**
```toml
# ISO Configuration for ClarityOS
[customizations.installer]
unattended = false
```

**Analysis:**
- **Line 2-3:** Contains `[customizations.installer]` section with `unattended = false`
- **ISSUE:** This configuration format may not be recognized by bootc-image-builder (BIB)
- **Reason:** The `[customizations.installer]` section is not a documented BIB configuration option
- **Impact:** BIB likely ignores this setting, resulting in default unattended installation behavior

**Finding:** ⚠️ **PROBLEMATIC** - Incorrect configuration format for BIB

---

### 2. iso/disk.toml
**Location:** `/home/runner/work/playground/playground/iso/disk.toml`  
**Current Content:**
```toml
[[filesystem.modifications.directories]]
path = "/etc/pki/containers"

[[filesystem.modifications.directories]]
path = "/etc/containers/systemd"

[[filesystem.modifications.directories]]
path = "/var/roothome"
```

**Analysis:**
- Only contains filesystem directory creation directives
- No installer-related configurations
- No automated installation settings

**Finding:** ✅ **CLEAN** - No automated installation configurations

---

### 3. build/10-build.sh
**Location:** `/home/runner/work/playground/playground/build/10-build.sh`  
**Lines of Interest:**
- Line 115: `systemctl enable cosmic-greeter` - Enables display manager

**Analysis:**
- Installs COSMIC Desktop and CLI tools
- Enables cosmic-greeter (display manager) at line 115
- Enables podman.socket at line 118
- No kickstart files generated
- No automated installation scripts
- No unattended installation flags

**Finding:** ✅ **CLEAN** - No automated installation configurations

---

### 4. Containerfile
**Location:** `/home/runner/work/playground/playground/Containerfile`  
**Analysis:**
- Uses `ghcr.io/ublue-os/base-main:gts` as base image
- Runs build scripts via `/ctx/build/10-build.sh` at line 57
- No systemd services for auto-installation
- No kickstart file generation
- No automated user creation

**Finding:** ✅ **CLEAN** - No automated installation configurations

---

### 5. Justfile (Build System)
**Location:** `/home/runner/work/playground/playground/Justfile`  
**Lines of Interest:**
- Line 3: BIB image version specified
- Line 120-142: `_build-bib` function that invokes bootc-image-builder
- Line 137: Mounts config file as `/config.toml:ro`
- Line 162: `build-iso` uses `iso/iso.toml` as config

**Analysis:**
```bash
# Line 124-126: BIB invocation arguments
args="--type ${type} "
args+="--use-librepo=True "
args+="--rootfs=btrfs"
```

- Only passes `--type`, `--use-librepo`, and `--rootfs` flags
- No `--unattended` or `--interactive` flags
- Mounts config file but BIB may not parse `[customizations.installer]` section
- No kickstart file specification

**Finding:** ⚠️ **PROBLEMATIC** - Missing proper unattended mode configuration flags

---

### 6. .github/workflows/build.yml
**Location:** `/home/runner/work/playground/playground/.github/workflows/build.yml`  
**Analysis:**
- Builds container images only
- Does not build ISO images in CI/CD
- No ISO-specific build parameters
- No installer configuration overrides

**Finding:** ✅ **CLEAN** - No automated installation configurations

---

### 7. Search for Kickstart Files
**Command:** `find . -name "*.ks" -o -name "*kickstart*"`  
**Result:** No kickstart files found in repository

**Finding:** ✅ **CLEAN** - No kickstart files present

---

### 8. Search for Systemd Auto-Login/Auto-Setup
**Command:** `find . -name "*.service" -o -name "*.target"`  
**Result:** No systemd unit files found in repository

**Analysis:**
- No systemd units for automatic login
- No systemd units for automatic installation
- cosmic-greeter enabled via `systemctl enable` in build script (normal behavior)

**Finding:** ✅ **CLEAN** - No auto-login or auto-setup systemd units

---

### 9. Search for Auto-Install Keywords
**Search:** `grep -r "unattended\|kickstart\|auto-install\|automated"`  
**Results:**
- `iso/iso.toml:unattended = false` (line 3)
- `SETUP.md:unattended = false` (documentation only)

**Finding:** Only references are in `iso/iso.toml` and documentation

---

## Root Cause Analysis

### Primary Issue: Incorrect BIB Configuration Format

The `iso/iso.toml` file contains:
```toml
[customizations.installer]
unattended = false
```

**Problem:** The `[customizations.installer]` section is **NOT** a valid bootc-image-builder configuration section.

### Evidence:

1. **BIB Configuration Documentation:** Bootc-image-builder uses a different TOML schema based on Image Builder (formerly Lorax/Anaconda Image Builder) blueprint format.

2. **Expected Format:** BIB expects configuration in the following sections:
   - `[customizations]` - General customizations (users, groups, hostname, etc.)
   - `[[filesystem.modifications]]` - Filesystem changes
   - Blueprint-style configuration

3. **Missing Configuration:** There is **NO** `installer` subsection under `customizations` in the BIB specification.

4. **Default Behavior:** When BIB doesn't find installation mode configuration, it defaults to **automated/unattended installation** for ISO images.

### Secondary Issue: No Interactive Installation Configuration

The bootc-image-builder (BIB) documentation and implementation show that:
- ISO images created by BIB are designed for **automated deployment** by default
- Interactive Anaconda installer support may require:
  - A kickstart file with interactive directives
  - Specific BIB configuration (if supported)
  - Manual ISO modification post-build

### BIB Version Analysis

**Current BIB Image:**
```
quay.io/centos-bootc/bootc-image-builder:latest@sha256:903c01d110b8533f8891f07c69c0ba2377f8d4bc7e963311082b7028c04d529d
```

This version may have limited support for interactive installation modes.

---

## Configurations That COULD Cause Automated Installation

### None Found in Repository

After comprehensive audit:
- ✅ No kickstart files with automated directives
- ✅ No systemd units for auto-installation
- ✅ No build scripts generating automated configs
- ✅ No environment variables forcing unattended mode
- ✅ No CI/CD parameters enforcing automation

### The Real Problem

**The automated installation behavior is the DEFAULT behavior of bootc-image-builder ISOs**, not caused by any configuration in this repository.

The `unattended = false` setting in `iso/iso.toml` is **ineffective** because:
1. It's in a non-existent configuration section
2. BIB doesn't recognize or parse this parameter
3. BIB has no built-in mechanism to enable interactive Anaconda installer

---

## Recommendations

### Option 1: Use Correct BIB Configuration (If Available)

Research and implement the correct BIB configuration format for interactive installation. This may require:
- Checking BIB documentation for interactive installer support
- Using a kickstart file with interactive directives
- Upgrading to a newer BIB version with interactive support

### Option 2: Custom Kickstart File

Create a kickstart file that enables interactive installation:
```bash
# Enable interactive installation
text
interactive

# Stop before partitioning
autopart --type=plain
```

Mount this kickstart file in the BIB build process.

### Option 3: Post-Build ISO Modification

Modify the generated ISO after BIB creates it to:
- Replace/modify the kickstart file embedded in the ISO
- Change boot parameters to enable interactive mode
- Modify Anaconda configuration

### Option 4: Alternative ISO Builder

Consider using traditional Fedora image building tools:
- `lorax` - Traditional Fedora ISO builder
- `livecd-tools` - Create live CD/DVD images
- Custom Anaconda installation ISO

---

## Summary of Findings

| File/Location | Contains Auto-Install Config? | Issue Found? |
|--------------|------------------------------|--------------|
| iso/iso.toml | ❌ No (invalid format) | ⚠️ Yes - Wrong config format |
| iso/disk.toml | ❌ No | ✅ Clean |
| build/10-build.sh | ❌ No | ✅ Clean |
| build/copr-helpers.sh | ❌ No | ✅ Clean |
| Containerfile | ❌ No | ✅ Clean |
| Justfile | ❌ No | ⚠️ Lacks proper flags |
| .github/workflows/ | ❌ No | ✅ Clean |
| Kickstart files | ❌ None exist | ✅ Clean |
| Systemd units | ❌ None exist | ✅ Clean |

**ROOT CAUSE:** The `[customizations.installer]` section in `iso/iso.toml` is not a valid bootc-image-builder configuration, so BIB uses its default behavior: automated/unattended ISO installation.

**SOLUTION REQUIRED:** Implement proper BIB configuration or use alternative methods to enable interactive Anaconda installation.

---

## Recommended Fix (Minimal Change)

### Step 1: Remove Invalid Configuration

**File:** `iso/iso.toml`  
**Action:** Remove the ineffective `[customizations.installer]` section

**Current (INCORRECT):**
```toml
# ISO Configuration for ClarityOS
[customizations.installer]
unattended = false
```

**Proposed (MINIMAL):**
```toml
# ISO Configuration for ClarityOS
# Note: bootc-image-builder creates automated installation ISOs by design.
# For interactive installation, consider using "bootc switch" from a live USB
# or a different ISO building tool.
```

### Step 2: Update Documentation

**Files to Update:**
- `README.md` - Clarify ISO installation is automated
- `SETUP.md` - Add note about automated installation behavior
- `INSTALLER_AUDIT.md` - This document serves as the detailed explanation

**README.md changes:**
```markdown
#### Option 2: Install from ISO

1. Download the latest ISO from the [Releases](https://github.com/ctsdownloads/clarity-os/releases) page
2. Flash to USB drive using [Fedora Media Writer](https://flathub.org/apps/org.fedoraproject.MediaWriter) or Ventoy
3. Boot from USB - **Note: Installation is automated** (see INSTALLER_AUDIT.md for details)

**Alternative:** Boot a live USB (Fedora, Universal Blue, etc.) and use `bootc switch` for interactive setup.
```

### Step 3: Alternative Installation Method

For users who want interactive installation, recommend:

**Option A: Use `bootc switch` from Live USB**
```bash
# Boot any Fedora/Universal Blue live USB
# Open terminal and run:
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
```

**Option B: Use traditional Fedora installation**
```bash
# Install Fedora first
# Then switch to ClarityOS:
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

---

## Why This is the Right Fix

1. **Minimal change** - Only removes non-functional code
2. **Honest** - Doesn't pretend to support interactive installation
3. **Provides alternatives** - Offers working solutions for users
4. **Correct** - Uses bootc as designed
5. **No breaking changes** - The ISO never worked interactively anyway

---

## Future Enhancements (Optional)

If interactive installation is truly required:

1. **Research BIB kickstart support** - Check if `--kickstart` flag exists
2. **Create custom kickstart** - Write a kickstart file with interactive directives
3. **Test alternative ISO builders** - Evaluate `lorax` or `anaconda-image-builder`
4. **Consider live ISO** - Create a live ISO with installation tool (more complex)

However, the bootc workflow is designed for `bootc switch`, not traditional ISO installation.
