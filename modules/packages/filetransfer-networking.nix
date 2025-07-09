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
  globalprotect-openconnect
  openconnect
  networkmanager-openconnect
]