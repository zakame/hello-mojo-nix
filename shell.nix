{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/51428e8d38271d14146211867984b8742d304ea4.tar.gz") {} }:

with pkgs;

let

  FutureAsyncAwait = perlPackages.buildPerlModule {
    pname = "Future-AsyncAwait";
    version = "0.43";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/Future-AsyncAwait-0.43.tar.gz";
      sha256 = "3c9670d1b39e7ba8b02ce6552f5b37adb5a900ac0108f28549121dd98e76714a";
    };
    buildInputs = [ perlPackages.TestRefcount ];
    propagatedBuildInputs = with perlPackages; [ Future XSParseSublike ];
    meta = {
      description = "Deferred subroutine syntax for futures";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  IOSocketSocks = buildPerlPackage {
    pname = "IO-Socket-Socks";
    version = "0.74";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLEG/IO-Socket-Socks-0.74.tar.gz";
      sha256 = "37f071a2cf4ba8f090a2297c6482b7a2c509eb52dcd6ce5d8035d4ee2c6824b1";
    };
    meta = {
      description = "Provides a way to create socks client or server both 4 and 5 version";
      license = stdenv.lib.licenses.free;
    };
  };

  NetDNSNative = buildPerlPackage {
    pname = "Net-DNS-Native";
    version = "0.22";
    src = fetchurl {
      url = "mirror://cpan/authors/id/O/OL/OLEG/Net-DNS-Native-0.22.tar.gz";
      sha256 = "108d9dedbab9ffaf6a0d01525526de1894884e950bfd833717e5cd38905c30d5";
    };
    meta = {
      description = "Non-blocking system DNS resolver";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  XSParseSublike = perlPackages.buildPerlModule {
    pname = "XS-Parse-Sublike";
    version = "0.10";
    src = fetchurl {
      url = "mirror://cpan/authors/id/P/PE/PEVANS/XS-Parse-Sublike-0.10.tar.gz";
      sha256 = "99a1bdda3ffa67514adb6aa189c902fa78dca41d778a42ae7079f604a045ac43";
    };
    buildInputs = [ perlPackages.TestFatal ];
    meta = {
      description = "XS functions to assist in parsing C<sub>-like syntax";
      license = with stdenv.lib.licenses; [ artistic1 gpl1Plus ];
    };
  };

  cpan = { inherit FutureAsyncAwait IOSocketSocks NetDNSNative XSParseSublike; };

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

      cpan.IOSocketSocks
      cpan.NetDNSNative
      cpan.FutureAsyncAwait
    ]))

    gitMinimal
  ];
}
