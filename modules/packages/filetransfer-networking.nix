{ pkgs, ... }: with pkgs; [
  flatpak
  tailscale
  filezilla
  postman
  wireshark
  pika-backup
  angryipscanner
  nmap
  dnsmasq # VM networking
  phodav # Share files with guest VMs
  # globalprotect-openconnect # CVE-2025-6558
  openconnect
  networkmanager-openconnect
]