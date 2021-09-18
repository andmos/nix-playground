## Darwin setup

```sh
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer
rm -rf result

rm ~/nixpkgs/darwin-configuration.nix
ln ./nix-playground/.nixpkgs/darwin-configuration.nix ./.nixpkgs/

darwin-rebuild switch
```