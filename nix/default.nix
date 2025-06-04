{ lib, stdenv, godot, gnutar, gzip, unzip, version ? "v0.9.2", godotPackages
, dust, alsa-lib, gcc-unwrapped, libGLU, libX11, libXcursor, libXext, libXfixes
, libXi, libXinerama, libXrandr, libXrender, libglvnd, libpulseaudio, zlib
, godot-version ? "4.4.1.stable" }:

stdenv.mkDerivation {
  pname = "recoil";
  version = version;

  src = fetchGit {
    url = "https://codeberg.org/rjust/ReCoil.git";
    rev = "8299f64e696f61592c083fb9c1be2eadf9140bed";
  };

  nativeBuildInputs =
    [ godot gnutar gzip unzip dust godotPackages.export-template ];
  buildInputs = [
    alsa-lib
    gcc-unwrapped.lib
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    libglvnd
    libpulseaudio
    zlib
  ];

  buildPhase = ''
    runHook preBuild

    # Canot create under /homeless-shelter
    export HOME=$(mktemp -d)

    # link godot export templates
    mkdir -p $HOME/.local/share/godot/export_templates/${godot-version}
    ln -sf ${godotPackages.export-template}/bin/godot-template $HOME/.local/share/godot/export_templates/${godot-version}/linux_release.x86_64

    mkdir -p $out/bin
    godot --headless --export-release "Linux/X11" $out/bin/recoil

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/share/{applications,icons/hicolor/128x128/apps}
    cp $src/icon.png $out/share/icons/hicolor/128x128/apps/recoil.png

    echo "[Desktop Entry]
    Exec=recoil
    GenericName=A zero-gravity arcade shooter without thrusters!
    Icon=recoil
    Name=ReCoil
    StartupNotify=true
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false" >> $out/share/applications/recoil.desktop
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/rjust/ReCoil";
    description = "A zero-gravity arcade shooter without thrusters!";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
    mainProgram = "recoil";
  };
}
