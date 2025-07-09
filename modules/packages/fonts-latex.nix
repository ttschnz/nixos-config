{ pkgs, ... }: with pkgs; [
  lmodern
  #pkgs.texlivePackages.cm-super
  (texlive.combine {
    inherit (texlive) scheme-medium 
    luatex enumitem inter censor pbox tokcycle titlesec xhfill
    fontawesome5 totalcount mdframed lipsum csquotes cancel cleveref
    titling cmbright geometry cm-super adjustbox threeparttable wrapfig
    floatflt framed biblatex biblatex-chicago xstring type1cm;
  })
  biber
  texstudio
  setzer
]