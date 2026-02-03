{ pkgs, ... }: with pkgs; [
  blackbox-terminal
  terminator
  wget
  tree
  fzf # fuzzy-find
  atuin # shell history
  dust # du
  btop # task-manager
  bat # cat with git integration
  tldr # shorter man-pages
  eza # readable ls
  zoxide # better cd
  taskwarrior3 # task
]