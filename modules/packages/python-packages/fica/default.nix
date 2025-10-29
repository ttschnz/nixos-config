{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, poetry-core
, numpy
, pandas
, scipy
, matplotlib
, nbformat
, networkx
, jupyter
, click
, dill
, fsspec
, ipylab
, jupytext
, python-on-whales
, wrapt
, docutils
, pyyaml
, sphinx
}:


buildPythonPackage rec {
  pname = "fica";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "chrispyles";
    repo = "fica";
    rev = "v${version}";
    sha256 = "sha256-A13xC8BGsPddsk8ZN2DeMCYc0phy/B4JD9shuoorOwg=";
  };

  pyproject = true;

  build-system = [ 
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    docutils
    pyyaml
    sphinx
  ];
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.4.0"' 'version = "0.4.1"'
  '';
  doCheck = false;  

  meta = with lib; {
    description = "A Python library for managing and documenting user configurations";
    homepage = "https://github.com/chrispyles/fica";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
