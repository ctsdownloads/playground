# Installation Configuration Audit - Final Report

## Executive Summary

This audit was conducted to identify why the ClarityOS ISO installer runs in unattended/automated mode instead of showing interactive Anaconda installation screens, despite `iso/iso.toml` containing `unattended = false`.

## Key Finding

**The `[customizations.installer]` section with `unattended = false` is NOT a valid bootc-image-builder configuration.**

Bootc-image-builder (BIB) silently ignores this section and uses its default behavior: creating automated deployment ISOs.

## Audit Scope

Every configuration file in the repository was examined:

### Files Audited (All Clean except iso/iso.toml)
- ✅ iso/disk.toml - No installer configs
- ✅ build/10-build.sh - No automation scripts
- ✅ build/copr-helpers.sh - Helper functions only
- ✅ Containerfile - Standard image build
- ✅ .github/workflows/ - All 4 workflow files checked
- ✅ Justfile - Build system only
- ✅ Kickstart files - None found (searched entire repo)
- ✅ Systemd units - None found (searched entire repo)

### Problem Found
- ⚠️ **iso/iso.toml** - Lines 2-3 contained invalid BIB configuration

## Root Cause

Bootc-image-builder creates **automated deployment ISOs by design**. It is not designed to create interactive Anaconda installer ISOs. The tool is meant for:
- Automated server deployments
- Cloud image provisioning
- Edge device installations

NOT for:
- Interactive desktop installations
- Manual partitioning
- User-interactive setup

## Changes Made

### 1. iso/iso.toml (FIXED)
**Before:**
```toml
# ISO Configuration for ClarityOS
[customizations.installer]
unattended = false
```

**After:**
```toml
# ISO Configuration for ClarityOS
#
# IMPORTANT: bootc-image-builder creates AUTOMATED installation ISOs by design.
# The ISO will automatically install ClarityOS to the first available disk.
#
# The [customizations.installer] section is NOT supported by bootc-image-builder.
# Setting "unattended = false" has NO EFFECT on BIB-generated ISOs.
# ...
(See file for complete documentation)
```

### 2. Documentation Updated
- **README.md** - Added warning about automated installation
- **SETUP.md** - Added detailed explanation and alternatives
- **INSTALLER_AUDIT.md** - 355-line comprehensive technical analysis
- **AUDIT_SUMMARY.md** - Quick reference summary

## Alternative Installation Methods

For users who need interactive installation:

### Option 1: Use `bootc switch` (Recommended)
```bash
# Boot any Fedora or Universal Blue live USB
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

### Option 2: Install Fedora First
```bash
# Install base Fedora interactively
# After installation:
sudo bootc switch ghcr.io/ctsdownloads/clarity-os:stable
sudo systemctl reboot
```

### Option 3: Pre-configure User in iso.toml
Edit `iso/iso.toml` to add a default user (requires ISO rebuild).

## Documents Created

1. **INSTALLER_AUDIT.md** (355 lines)
   - Complete technical analysis
   - Root cause investigation
   - Detailed findings for each file
   - Recommended fixes

2. **AUDIT_SUMMARY.md** (107 lines)
   - Quick reference
   - Table of all audited files
   - Line-by-line issue tracking

3. **AUDIT_README.md** (this file)
   - Executive summary
   - Key findings
   - Changes made

## Verification

- ✅ All shell scripts pass shellcheck
- ✅ TOML files are syntactically valid
- ✅ No automated installation configs found anywhere
- ✅ Documentation is clear and accurate
- ✅ Alternative installation methods provided

## Conclusion

**No configurations were found that enable automated installation.** The automated behavior is the default and intended behavior of bootc-image-builder.

The only issue was the invalid `[customizations.installer]` configuration that gave false expectations. This has been removed and replaced with clear documentation.

## Impact

- Users will now understand that ISOs are automated by design
- Alternative installation methods are clearly documented
- No false expectations from invalid configuration
- Repository documentation is now accurate and helpful

## Recommendation

Accept this as the correct behavior or consider using alternative ISO building tools (lorax, anaconda-image-builder) if true interactive Anaconda installation is required.

---

**Audit Completed:** 2025-10-30  
**Auditor:** GitHub Copilot  
**Status:** ✅ Complete
