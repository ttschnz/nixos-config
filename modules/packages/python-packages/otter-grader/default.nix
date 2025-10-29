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
, callPackage
}:


buildPythonPackage rec {
  pname = "otter-grader";
  version = "6.1.6";

  src = fetchFromGitHub {
    owner = "ucbds-infra";
    repo = "otter-grader";
    rev = "v${version}";
    sha256 = "sha256-bqBwDbxnvRm7W9r87YK9vwi3sSyoyqbdnqVs5HxOzsg=";
  };

  pyproject = true;

  build-system = [ 
    poetry-core
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    scipy
    matplotlib
    nbformat
    networkx
    jupyter
    click
    dill
    fsspec
    ipylab
    jupytext
    python-on-whales
    wrapt
    (callPackage ../fica/default.nix { })
  ];

  doCheck = false;
  # fica is missing but only optional.
  dontUsePythonRuntimeDepsCheckHook = true;


  meta = with lib; {
    description = "A Python and R autograding solution";
    homepage = "https://github.com/ucbds-infra/otter-grader";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
