{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, numpy
, pandas
, scipy
, matplotlib
, nbformat
, networkx
, jupyter
}:


buildPythonPackage rec {
  pname = "teaching-optimization";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "michelbierlaire";
    repo = "teaching_optimization";
    rev = "v${version}";
    sha256 = "09s6lq72wf6hws130l2y93i217clhc01088krhnlcyd84sy8ra9y";
  };

  pyproject = true;

  build-system = [ setuptools wheel ];

  # No explicit propagated dependencies listed upstream, adjust if needed
  propagatedBuildInputs = [ 
    numpy pandas scipy matplotlib nbformat networkx jupyter
  ];

  # Disable tests for now (no info about framework)
  doCheck = false;

  meta = with lib; {
    description = "Teaching material for optimization courses (EPFL)";
    homepage = "https://github.com/michelbierlaire/teaching_optimization";
    license = licenses.free;
    maintainers = with maintainers; [ ];
  };
}
