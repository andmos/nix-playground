with import <nixpkgs> {};

stdenv.mkDerivation {
    name = "local-env-example";

    buildInputs = [
        pkgs.gnused
        pkgs.neofetch
        pkgs.yamllint
    ];
}