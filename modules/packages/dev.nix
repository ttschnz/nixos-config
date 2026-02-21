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
  # wasmer # currently broken
  gcc
  avrdude
  go
  (python313.withPackages (p: with p; [
    pypdf tkinter pip sympy meson cmake requests torpy numpy scipy
    pygobject3 pycairo flask werkzeug waitress websockets bitarray
    ipykernel notebook jupyter seaborn plotly torch torchvision tqdm #docling
    yfinance hf-xet scikit-learn datasets peft xgboost
    (callPackage python-packages/otter-grader/default.nix { })
    (callPackage python-packages/teaching-optimization/default.nix { })
  ]))
  jupyter-all
  nodejs_22
  # nodePackages.webpack-cli
  # nodePackages.webpack
  elmPackages.elm
  ncurses
  (octaveFull.withPackages (p: with p; [ 
    control symbolic signal
    ]))
  zed-editor
  expect
  platformio
  socat
  simulide_1_1_0

  cargo-generate
  ravedude
  esp-generate
  espup

  usbutils
  dig
  unzip
  lsof


  # requirements for development of MSP-board
  mspdebug
  libusb1
  msp430debuglib
  libusb-compat-0_1
  gcc-unwrapped
]