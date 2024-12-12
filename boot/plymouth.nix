{pkgs, ...}: {
  boot.plymouth = {
    enable = true;
    theme = "breeze";
    font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFontPropo-Italic.ttf";
  };
}
