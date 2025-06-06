{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qmake,
  qtwebsockets,
  minizinc,
  makeWrapper,
}:

let
  executableLoc =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/MiniZincIDE.app/Contents/MacOS/MiniZincIDE"
    else
      "$out/bin/MiniZincIDE";
in
stdenv.mkDerivation rec {
  pname = "minizinc-ide";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "MiniZinc";
    repo = "MiniZincIDE";
    rev = version;
    hash = "sha256-gUsv4peZhWrwujRloNisuSf/0Wx5W5xRusAHJCx0wNA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    makeWrapper
  ];
  buildInputs = [
    qtbase
    qtwebsockets
  ];

  sourceRoot = "${src.name}/MiniZincIDE";

  dontWrapQtApps = true;

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      mv $out/bin/MiniZincIDE.app $out/Applications/
    ''
    + ''
      wrapProgram ${executableLoc} \
        --prefix PATH ":" ${lib.makeBinPath [ minizinc ]} \
        --set QT_QPA_PLATFORM_PLUGIN_PATH "${qtbase}/lib/qt-6/plugins/platforms"
    '';

  meta = with lib; {
    homepage = "https://www.minizinc.org/";
    description = "IDE for MiniZinc, a medium-level constraint modelling language";
    mainProgram = "MiniZincIDE";
    longDescription = ''
      MiniZinc is a medium-level constraint modelling
      language. It is high-level enough to express most
      constraint problems easily, but low-level enough
      that it can be mapped onto existing solvers easily and consistently.
      It is a subset of the higher-level language Zinc.
    '';
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = [ maintainers.dtzWill ];
  };
}
