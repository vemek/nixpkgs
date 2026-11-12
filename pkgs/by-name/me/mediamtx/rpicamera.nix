{
  stdenv,
  meson,
  ninja,
  fetchFromGitHub,
  fetchurl,
  cmake,
  libcamera,
  pkg-config,
  freetype,
  libjpeg_turbo,
  openh264,
  xxd,
}: let
  ibmPlexMono = fetchurl {
    url = "https://github.com/IBM/plex/raw/v6.4.2/IBM-Plex-Mono/fonts/complete/ttf/IBMPlexMono-Medium.ttf";
    hash = "sha256-C+3j3r3qhIi7uSf48GUNkVBzIJc0pn/ozVozILVyURw=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "mediamtx-rpicamera";
    version = "2.9.1";

    src = fetchFromGitHub {
      owner = "bluenviron";
      repo = "mediamtx-rpicamera";
      tag = "v${finalAttrs.version}";
      hash = "sha256-opTE58PMhG0k8Y8zAeheAb6aRN0Qq+ozMDPx1yyiHT0=";
    };

    nativeBuildInputs = [meson ninja cmake pkg-config xxd];
    buildInputs = [libcamera freetype libjpeg_turbo openh264];

    postPatch = ''
      substituteInPlace meson.build \
        --replace-fail "'libjpeg', version: '<3.0.0'," "'libjpeg', version: '<4.0.0',"

      substituteInPlace text_font.sh \
        --replace-fail "wget -O text_font.ttf https://github.com/IBM/plex/raw/v6.4.2/IBM-Plex-Mono/fonts/complete/ttf/IBMPlexMono-Medium.ttf" \
          "cp ${ibmPlexMono} text_font.ttf"
    '';
  })
