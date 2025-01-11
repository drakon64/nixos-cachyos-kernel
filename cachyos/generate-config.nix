{
  callPackage,
  fetchurl,
  kernelConfig,
  stdenvNoCC,
}:
let
  sources = callPackage ./sources.nix { };
  srcName = "linux-${sources.linuxVersion}";

  pkgbuild = fetchurl {
    url = "https://raw.githubusercontent.com/CachyOS/linux-cachyos/baea61cb7f46030c1f24a65b789370e526629b92/linux-cachyos-lts/PKGBUILD";
    hash = "sha256-z3rMwSa+FK/A5YoPlFystwTtIs8oBqR7apCDgRbMAEw=";
  };
in
stdenvNoCC.mkDerivation {
  name = "config";
  src = null;

  phases = [
    "unpackPhase"
    "configurePhase"
    "installPhase"
  ];

  unpackPhase = ''
    cp -r --reflink=auto ${sources.linux} ${srcName}
    chmod -R u=rwX,g=rX,o=rX ${srcName}

    cp --reflink=auto ${kernelConfig} config
    touch ${srcName}/.config
    chmod u=rw,g=r,o=r ${srcName}/.config

    cp --reflink=auto ${pkgbuild} PKGBUILD
    cp --reflink=auto ${sources.cachyos-base-all} 0001-cachyos-base-all.patch
    cp --reflink=auto ${sources.bore-cachy} 0001-bore-cachy.patch
  '';

  configurePhase = ''
    source PKGBUILD
    export _use_auto_optimization=""
    patchShebangs --build ${srcName}/scripts/config

    OLD_PWD=$(pwd)
    prepare || exit 0
    cd "$OLD_PWD"
  '';

  installPhase = ''
    mkdir $out
    cp --reflink=auto ${srcName}/config-${sources.linuxVersion}-1-cachyos-lts $out/config
  '';
}
