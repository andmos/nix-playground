# Isolated shell with packages from list '$ nix-shell nix-shell-setup.nix'

with import <nixpkgs> {};

stdenv.mkDerivation {
    name = "local-env-example";

    buildInputs = [
        pkgs.gnused
        pkgs.neofetch
        pkgs.yamllint
        pkgs.htop
    ];
}