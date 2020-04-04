# with import <nixpkgs> { config = { allowUnfree = true; }; };
with import <nixpkgs> { };
with pkgs;
stdenv.mkDerivation rec {
  name = "robo-instructus";
  version = "1.0";
  buildInputs = [
    pkgs.unzip
    alsaLib
    glibc
    xlibs.libxcb
    xlibs.libX11
    xlibs.libXcursor
    xlibs.libXi
    xlibs.libXrandr
    libglvnd
  ];
  src = ./robo-instructus-linux.zip;
  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv robo_instructus $out/bin/robo-instructus
    mv lib/* $out/lib/
  '';
  dontPatchELF = true;
  preFixup = let
    libPath = lib.makeLibraryPath [
      alsaLib
      glibc
      xlibs.libxcb
      xlibs.libX11.out
      xlibs.libXcursor
      xlibs.libXi
      xlibs.libXrandr
      libglvnd
    ];
  in ''
    rPath="${libPath}:$out/lib"
    echo $rPath
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $rPath \
      $out/bin/robo-instructus
  '';
  meta = with stdenv.lib; {
    homepage = "https://www.roboinstruct.us/";
    description = "A programming game";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ "little-dude" ];
  };
}
