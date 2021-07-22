
{ stdenv, lib, fetchurl, libunwind, openssl, icu, libuuid, zlib, curl, patchelf }:
let
  rpath = lib.makeLibraryPath [ stdenv.cc.cc libunwind libuuid icu openssl zlib curl ];
  dynamicLinker = stdenv.cc.bintools.dynamicLinker;
  platform = "osx-x64";
  sha512 = "19360f4b82422b768cb15268edbac9b2cfef77a31985a5b75a46222a20ef2434ad263fa5ef95f1dba000b8bf5e15d99a698575f8803052596a54a3d8c67b1f16";
in stdenv.mkDerivation rec {
  pname = "dotnet-sdk";
  version = "5.0.302";

  src = fetchurl {
    inherit sha512;
    url = "https://dotnetcli.azureedge.net/dotnet/Sdk/${version}/${pname}-${version}-${platform}.tar.gz";
  };

  sourceRoot = ".";

  dontPatchELF = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r ./ $out
    ln -s $out/dotnet $out/bin/dotnet
    runHook postInstall
  '';

  postFixup = if stdenv.isLinux then ''
    patchelf --set-interpreter "${dynamicLinker}" --set-rpath "${rpath}" $out/dotnet
    find $out -type f -name "*.so" -exec patchelf --set-rpath '$ORIGIN:${rpath}' {} ';'
    find $out -type f -name "apphost" -exec patchelf --set-interpreter "${dynamicLinker}" --set-rpath '$ORIGIN:${rpath}' {} ';'
  '' else '''';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dotnet --info
  '';

  meta = with lib; {
    homepage = https://dotnet.microsoft.com/;
    description = "The .NET software framework SDK";
    platforms = [ "x86_64-darwin" ];
    maintainers = with maintainers; [ andmos ];
    license = licenses.mit;
  };
}