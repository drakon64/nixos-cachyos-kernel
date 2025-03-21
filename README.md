# nixos-cachyos-kernel

The CachyOS LTS kernel for NixOS.

This is built from the default NixOS kernel config + additional config sourced from the CachyOS PKGBUILD and patches. Therefore, the config may not exactly match that of CachyOS.

For the CachyOS Stable, Server, and Hardened kernels, see [Chaotic Nyx](https://www.nyx.chaotic.cx).

## Installation

### Binary cache

First, add the binary cache:

```nix
nix.settings = {
  substituters = [ "https://drakon64-nixos-cachyos-kernel.cachix.org" ];
  trusted-public-keys = [ "drakon64-nixos-cachyos-kernel.cachix.org-1:J3gjZ9N6S05pyLA/P0M5y7jXpSxO/i0rshrieQJi5D0=" ];
};
```

then run `sudo nixos-rebuild switch` to update your Nix config.

### Adding the input

This repository must then be added as an input to your config:

<!-- 
#### non-Flakes

TODO

npins -->

#### Flakes

In your `flake.nix` file:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-cachyos-kernel.url = "github:drakon64/nixos-cachyos-kernel";
  };
  
  outputs =
    {
      self,
      nixpkgs,
      nixos-cachyos-kernel,
    }:
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            nixos-cachyos-kernel.nixosModules.default
          ];
        };
      };
    };
}
```

### Rebuilding the system

Following this, you can then add the kernel to your NixOS config like so:

```nix
boot.kernelPackages = with pkgs; linuxPackagesFor linuxPackages_cachyos;
```

Alternatively you can use a Clang-built kernel with:

```nix
boot.kernelPackages = with pkgs; linuxPackagesFor linuxPackages_cachyos_lto;
```

At present the Clang-built kernel does not have LTO enabled.

Finally, run `sudo nixos-rebuild boot` and reboot into the new kernel.

## Credits

* The CachyOS Team for providing the patches and PKGBUILD that this package uses
* [niklaskorz](https://github.com/niklaskorz/) and [NotAShelf](https://github.com/NotAShelf/) for explaining Linux kernel packaging with Nix to me
