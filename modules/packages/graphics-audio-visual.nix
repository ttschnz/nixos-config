{ pkgs, ... }: with pkgs; [
  gimp
  libsForQt5.kdenlive # video editor
  mediainfo
  vlc
  clapper
  freecad-wayland
  fritzing
  prusa-slicer
  inkscape-with-extensions
  gst_all_1.gstreamer
  gst_all_1.gst-plugins-base
  gst_all_1.gst-plugins-good
  gst_all_1.gst-plugins-bad
  gst_all_1.gst-plugins-ugly
  gst_all_1.gst-libav
  gst_all_1.gst-vaapi
  gobject-introspection
  libinput
  spotify
  ffmpeg
]