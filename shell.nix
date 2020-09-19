{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/51428e8d38271d14146211867984b8742d304ea4.tar.gz") {} }:

with pkgs;

let

  cpan = builtins.attrValues (callPackage ./cpan.nix {});

in

mkShell {
  buildInputs = [
    nix-generate-from-cpan
    (perl.withPackages (ps: with ps; [
      Mojolicious
      CpanelJSONXS
      EV
      IOSocketSSL
      RoleTiny
    ] ++ cpan))

    gitMinimal
  ];
}
