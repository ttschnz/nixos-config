{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, setuptools
, wheel
, numpy
, librosa
, scipy
, cython
, callPackage
}:


buildPythonPackage rec {
  pname = "basic-pitch";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "basic-pitch";
    rev = "v${version}";
    sha256 = "eLgf76dA+WznTzo0L9QTIBr/dTVYPYtSkXKT81h5KEI=";
  };

  # pyproject = true;

  build-system = [ setuptools wheel ];

  # No explicit propagated dependencies listed upstream, adjust if needed
  propagatedBuildInputs = [
    cython
    librosa
    numpy
    scipy
    (callPackage ../pretty_midi/default.nix { })
    python.pkgs.mir-eval
    python.pkgs.tensorflow
    python.pkgs.resampy
    # (python.pkgs.resampy.overrideAttrs (old: {
    #   src = python.pkgs.fetchPypi {
    #     pname = "resampy";
    #     version = "0.4.2";
    #     sha256 = "CkaebduJlW9P1siHKDAOS70Yb65WndT9F9rlGpHLqhU=";
    #   };
    # }))
    # (python.pkgs.tensorflow.overrideAttrs (old: {
    #   src = python.pkgs.fetchPypi {
    #     pname = "tensorflow";
    #     version = "2.14.1";
    #     sha256 = "eLgf76dA+WznTzo0L9QTIBr/dTVYPYtSkXKT81h5KEI=";
    #   };
    # }))
  ];


  # Disable tests for now (no info about framework)
  pythonRuntimeDepsCheck = false;
  dontUsePythonRuntimeDepsCheckHook = true;
  doCheck = false;

  meta = with lib; {
    description = "A lightweight yet powerful audio-to-MIDI converter with pitch bend detection";
    homepage = "https://basicpitch.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
