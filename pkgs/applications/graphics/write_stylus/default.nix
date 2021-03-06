{ stdenv, lib, qtbase, qtsvg, libglvnd, fetchurl, makeDesktopItem }:
let
  # taken from: https://www.iconfinder.com/icons/50835/edit_pencil_write_icon
  # license: Free for commercial use
  desktopIcon = fetchurl {
    url = "https://www.iconfinder.com/icons/50835/download/png/256";
    sha256 = "0abdya42yf9alxbsmc2nf8jwld50zfria6z3d4ncvp1zw2a9jhb8";
  };
in
stdenv.mkDerivation rec {
  pname = "write_stylus";
  version = "209";

  desktopItem = makeDesktopItem {
    name = "Write";
    exec = "Write";
    comment = "A word processor for handwriting";
    icon = desktopIcon;
    desktopName = "Write";
    genericName = "Write";
    categories = "Office;Graphics";
  };

  src = fetchurl {
    url = "http://www.styluslabs.com/write/write${version}.tar.gz";
    sha256 = "1p6glp4vdpwl8hmhypayc4cvs3j9jfmjfhhrgqm2xkgl5bfbv2qd";
  };

  sourceRoot = ".";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -R Write $out/
    # symlink the binary to bin/
    ln -s $out/Write/Write $out/bin/Write

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';
  preFixup = let
    libPath = lib.makeLibraryPath [
      qtbase            # libQt5PrintSupport.so.5
      qtsvg             # libQt5Svg.so.5
      stdenv.cc.cc.lib  # libstdc++.so.6
      libglvnd          # ibGL.so.1
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/Write/Write
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.styluslabs.com/";
    description = "Write is a word processor for handwriting.";
    platforms = platforms.linux;
    license = stdenv.lib.licenses.unfree;
    maintainers = with maintainers; [ oyren ];
  };
}
