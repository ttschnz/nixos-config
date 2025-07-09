#!/bin/bash
set -e  # exit immediately on error
trap "mv secrets/secrets.nix.back secrets/secrets.nix" EXIT

# Handle "--upgrade" argument
for arg in "$@"; do
  if [[ "$arg" == "--upgrade" ]]; then
    echo "Upgrading flake"
    nix flake update
  fi
done

# Check for uncommitted changes
if [[ -n $(git status --porcelain) ]]; then
  read -p "Do you want to continue with a dirty git tree? (y/n): " answer
  case "$answer" in
    [Yy]* )
      echo "Continuing..."
      ;;
    * )
      echo "Aborting."
      exit 1
      ;;
  esac
fi


echo "Rebuilding NixOS..."

# Inject secrets temporarily
cp secrets/secrets.nix secrets/secrets.nix.back
sops -d secrets/secrets.yaml | bash ./secrets/inline.sh
git update-index --assume-unchanged secrets/secrets.nix

# Perform rebuild
sudo nixos-rebuild switch --flake ~/nixos-config || true

# revert changes to secrets.nix
git update-index --no-assume-unchanged secrets/secrets.nix
mv secrets/secrets.nix.back secrets/secrets.nix