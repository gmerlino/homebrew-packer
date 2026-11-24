# Homebrew Packer MPL

Packer 1.9.5, the final MPL-2.0 release, built from pinned upstream source with the current Homebrew Go compiler. Newer upstream releases use BUSL; this tap intentionally does not follow them. This is a legacy version maintained locally, not a supported upstream release branch. Plugin licenses and compatibility must be evaluated separately.

```sh
brew install gmerlino/packer/packer@1.9
/opt/homebrew/opt/packer@1.9/bin/packer version
brew test gmerlino/packer/packer@1.9
```

The formula is keg-only so it can be tested alongside another Packer installation. After validating the replacement and removing or unlinking the previous formula, activate the usual command with:

```sh
brew link --force gmerlino/packer/packer@1.9
```

The formula leaves user templates, configuration and plugin directories untouched. It uses Packer's normal plugin discovery; no wrapper appends the entire Homebrew bin directory to PACKER_PLUGIN_PATH.

## Validation

Validated on Apple Silicon with Go 1.27.4:

- Source build and executable version 1.9.5.
- HCL validation, a real local null-builder run with communicator disabled, shell-local provisioning, and manifest creation in the Homebrew test.
- Homebrew dynamic linkage check.
- An existing UTM 0.3.1 plugin was discovered by the linked packer command and its describe handshake passed (SDK 0.6.0, API x5.0, protocol v2).
- Syntax validation of seven existing template groups agreed with Packer 1.9.4; project files and Git state were preserved.

These tests do not claim to build every cloud or hypervisor image. No cloud resources or virtual machines were created. External provider plugins were not installed or upgraded during migration.
