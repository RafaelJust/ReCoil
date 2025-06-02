{ lib, stdenv, godot, gnutar, gzip, unzip, version ? "v0.9.2"
, godot-export-templates-bin }:

stdenv.mkDerivation {
  pname = "recoil";
  version = version;

  src = fetchGit {
    url = "https://codeberg.org/rjust/ReCoil.git";
    rev = "15f9b54f29c35bfc4340a251252a0fde21d1a85f";
  };

  nativeBuildInputs = [ godot gnutar gzip unzip ];

  buildPhase = ''
    runHook preBuild

    # Caanot create under /homeless-shelter
    export HOME=$TMPDIR

    # link godot export templates
    mkdir -p $HOME/.local/share/godot
    ln -sf ${godot-export-templates-bin}/share/godot/templates $HOME/.local/share/godot
    mkdir -p $out/bin
    godot --headless --export-release "Linux/X11" $out/bin/recoil

    runHook postBuild
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
