{
  lib,
  fetchzip,
  fetchpatch,
}:
let
  linuxVersion = "6.12.19";
  linuxMinorVersion = lib.versions.majorMinor linuxVersion;
  linuxHash = "sha256-9Uq2kgoSe42EPUEwlEP2ai8c8VFl+aZ/DTPrwBHagyY=";

  cachyosCommit = "934066f8d45279f6ffd38e7e63542d9312c63556";

  cachyosHash = "sha256-WbACCKuU9+Pc8Tnb2xVmDrdWmTTG4/x59flzWVdzrB8=";
  boreHash = "sha256-f9zyXVYJvuOVOzohUPIrzqXCVMyFoOE9UubBxrZfXP8=";
in
{
  inherit linuxVersion linuxMinorVersion;

  linux = fetchzip {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major linuxVersion}.x/linux-${linuxVersion}.tar.xz";
    hash = linuxHash;
  };

  cachyos-base-all = fetchpatch {
    url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/${cachyosCommit}/${linuxMinorVersion}/all/0001-cachyos-base-all.patch";
    hash = cachyosHash;
  };

  bore-cachy = fetchpatch {
    url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/${cachyosCommit}/${linuxMinorVersion}/sched/0001-bore-cachy.patch";
    hash = boreHash;
  };
}
