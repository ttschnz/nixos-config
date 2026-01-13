{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, numpy
, python
, callPackage
}:

buildPythonPackage rec {
  pname = "pretty_midi";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "craffel";
    repo = "pretty-midi";
    rev = "${version}";
    sha256 = "sha256-hkhthjTLWVVMHEhWi63rh6hAOZZ6fVMwbBhYvC9xXc8=";
  };

  pyproject = true;

  build-system = [ 
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    python.pkgs.mido
    python.pkgs.six
    python.pkgs.importlib-resources
  ];

  meta = with lib; {
    description = "Functions and classes for handling MIDI data conveniently.";
    homepage = "https://github.com/craffel/pretty-midi/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
