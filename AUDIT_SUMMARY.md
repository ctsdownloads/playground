# Configuration Audit Summary

## Files That Could Affect Installer Behavior - Complete Analysis

### ✅ CLEAN - No Automated Installation Configurations

1. **iso/disk.toml** - Only filesystem directory creation, no installer configs
2. **build/10-build.sh** - Package installation only, no automated installation scripts
3. **build/copr-helpers.sh** - Helper functions only, no installer configs
4. **Containerfile** - Standard image build, no auto-install services
5. **.github/workflows/build.yml** - Builds container images only, not ISOs
6. **.github/workflows/clean.yml** - Image cleanup only
7. **.github/workflows/validate-flatpaks.yml** - Validation only
8. **.github/workflows/validate-shellcheck.yml** - Linting only
9. **Justfile** - Build scripts, no automated installation flags
10. **No kickstart files** - Searched entire repository, none found
11. **No systemd auto-login units** - None found in repository
12. **No systemd auto-install services** - None found in repository

### ⚠️ PROBLEMATIC - Invalid/Ineffective Configurations

1. **iso/iso.toml (FIXED)**
   - **Location:** Line 2-3 (before fix)
   - **Issue:** `[customizations.installer]` with `unattended = false`
   - **Problem:** This section is NOT a valid bootc-image-builder configuration
   - **Effect:** BIB silently ignores it, using default automated installation
   - **Fix Applied:** Removed invalid section, added clear documentation

## Root Cause

**The installer runs in unattended mode because:**

1. Bootc-image-builder (BIB) creates **automated deployment ISOs by design**
2. The `[customizations.installer]` section is **not part of BIB's TOML specification**
3. BIB **silently ignores unknown configuration sections**
4. Without valid configuration, BIB uses its **default behavior: automated installation**

## What Was NOT Found (Confirmed Clean)

- ❌ No kickstart files with automated directives
- ❌ No `--unattended` flags in build commands
- ❌ No systemd units enabling auto-login
- ❌ No systemd units enabling auto-installation
- ❌ No environment variables forcing automation
- ❌ No CI/CD parameters enforcing unattended mode
- ❌ No scripts generating automated installation configs
- ❌ No hidden configuration files in .git or other directories

## Files Modified to Fix Issue

1. **iso/iso.toml**
   - Removed: Invalid `[customizations.installer]` section
   - Added: Clear documentation about BIB behavior
   - Added: Examples of valid BIB configuration
   - Added: Alternative installation methods

2. **INSTALLER_AUDIT.md**
   - Created: Comprehensive 355-line audit document
   - Details: Root cause analysis
   - Provides: Recommended fixes and alternatives

3. **README.md**
   - Updated: ISO installation section (lines 52-66)
   - Added: Warning about automated installation
   - Added: Alternative installation method (bootc switch)

4. **SETUP.md**
   - Updated: ISO Generation section (lines 222-254)
   - Added: Detailed explanation of automated behavior
   - Added: Valid vs invalid configuration examples
   - Added: Interactive installation alternatives

## Exact Line Numbers of Problematic Configurations

### Before Fix:
- **iso/iso.toml:2-3** - `[customizations.installer]` and `unattended = false`

### After Fix:
- **iso/iso.toml:1-25** - Comprehensive documentation, invalid config removed

## Summary Table

| File | Line Numbers | Issue | Status |
|------|-------------|-------|--------|
| iso/iso.toml | 2-3 (old) | Invalid BIB config section | ✅ Fixed |
| iso/disk.toml | All | No issues found | ✅ Clean |
| build/10-build.sh | All | No issues found | ✅ Clean |
| build/copr-helpers.sh | All | No issues found | ✅ Clean |
| Containerfile | All | No issues found | ✅ Clean |
| Justfile | 120-142 | Missing flags (inherent to BIB) | ℹ️ Documented |
| .github/workflows/* | All | No issues found | ✅ Clean |
| Kickstart files | N/A | None exist | ✅ Clean |
| Systemd units | N/A | None exist | ✅ Clean |

## Conclusion

**Only ONE configuration issue was found:**  
The invalid `[customizations.installer]` section in `iso/iso.toml` that gave false expectations.

**No automated installation configurations were found anywhere in the repository.**

The automated behavior is the **default and intended behavior** of bootc-image-builder ISOs, not caused by any configuration in this repository.

All issues have been addressed through:
1. Removing invalid configuration
2. Adding comprehensive documentation
3. Providing alternative installation methods
