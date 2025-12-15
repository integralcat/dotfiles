# Nix profile

### To update all packages at once inside nixpkgs

```zsh
nix profile upgrade --all
```

> Use `nix profile upgrade <package_name>` to upgrade specific package

> `# nix profile upgrade --regex '.*vim.*'` to use regex

#### Options
`--all` match all the packages of the profile
`--profile` profile to operate on
`--regex` A regular expression to match one or more packages in the profile.

# Nix flake

### nix flake check
This command verifies that the flake specified by flake reference flake-url can be evaluated successfully (as detailed below), and that the derivations specified by the flake's checks output can be built successfully.

```zsh
nix flake check
```

`--all-systems` Check the outputs for all systems.
`--no-build` Do not build checks.

*example*
```zsh
nix flake check --no-build github:NixOS/patchelf
```
