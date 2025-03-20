{
  pkgs ? import <nixpkgs> { },
}:
rec {
  linuxPackages_cachyos = pkgs.callPackage cachyos/package.nix { };
  linuxPackages_cachyos_lto = linuxPackages_cachyos.override { clang = true; };

  kernelConfig =
    let
      sources = pkgs.callPackage cachyos/sources.nix { };
    in
    pkgs."linuxPackages_${
      builtins.replaceStrings [ "." ] [ "_" ] sources.linuxMinorVersion
    }".kernel.configfile;

  generateConfig = pkgs.callPackage cachyos/generate-config.nix { inherit kernelConfig; };
}
