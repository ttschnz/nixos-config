{ pkgs, ... }: with pkgs; [
  age
  sops
  yq
  neovim
  git
  git-lfs
  gh
  cargo
  rustc
  rustPlatform.rustLibSrc
  rustfmt
  clippy
  clang
  zstd
  xz
  openssl
  gtk4
  libadwaita
  wasm-pack
  wasm-bindgen-cli
  gnumake
  pkg-config
  libnotify
  nix-tree
  wasmer
  gcc
  avrdude
  go
  (python312.withPackages (p: with p; [
    pypdf tkinter pip sympy meson cmake requests torpy numpy scipy
    pygobject3 pycairo flask werkzeug waitress websockets bitarray
    ipykernel notebook jupyter seaborn plotly torch torchvision tqdm docling
    yfinance hf-xet scikit-learn datasets peft
    (callPackage python-packages/otter-grader/default.nix { })
    (callPackage python-packages/teaching-optimization/default.nix { })
  ]))
  jupyter-all
  nodejs_22
  nodePackages.webpack-cli
  nodePackages.webpack
  elmPackages.elm
  ncurses
  (octaveFull.withPackages (p: with p; [ 
    control symbolic
    ]))
  zed-editor
  expect
]