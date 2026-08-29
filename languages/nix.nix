# line comment
/* block
   comment */
{ pkgs ? import <nixpkgs> { }, lib, ... }@args:

let
  version = "1.2.3";
  count = -42;
  ratio = 0.75;
  flags = [ "-O2" "-g" ] ++ [ "-Wall" ];
  base = { a = 1; nested = { deep = true; }; };
  merged = base // { b = null; };
  greet = name: "hello ${name}\n\t\"quoted\"";
  add = a: b: a + b;
  mkOpt = { name, default ? false, ... }: { inherit name default; };
  script = ''
    export VERSION=${version}
    echo ${toString count} && ${greet "world"}
  '';
in
assert lib.versionAtLeast version "1.0";

rec {
  inherit version flags;
  inherit (pkgs) stdenv fetchurl;

  localPath = ./src/main.c;
  homePath = ~/.config/app;
  searchPath = <nixpkgs/lib>;
  upstream = https://example.com/pkg-1.2.3.tar.gz;
  passthru = args.lib or null;

  checks = {
    eq = version == "1.2.3";
    ne = count != 0;
    both = true && !false;
    either = false || 1 < 2;
    implies = (ratio >= 0.5) -> (count <= 0);
    hasAttr = base ? nested;
    fallback = base.missing or "none";
    deep = base.nested.deep;
    sum = add 1 2;
    opt = mkOpt { name = "verbose"; };
    keys = builtins.attrNames merged;
  };

  names = builtins.map (x: "pkg-${x}") [ "a" "b" ];
  env = with pkgs; [ git curl ];

  drv = stdenv.mkDerivation {
    pname = "sample";
    inherit version;
    src = fetchurl {
      url = upstream;
      sha256 = builtins.hashString "sha256" version;
    };
    buildPhase = if checks.eq then script else throw "bad version";
    meta = { license = lib.licenses.mit; broken = false; };
  };
}
