{ pkgs, ... }:

{
  home.username = "cuichen";
  home.homeDirectory = "/home/cuichen";

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-chinese-addons
    ];
  };

  home.file = {
    "/home/cuichen/.local/share/fcitx5/rime/default.custom.yaml".source =
      ../files/rime/default.custom.yaml;
  };

  home.packages = with pkgs; [
    nerd-fonts.ubuntu-sans
    maple-mono.CN
    copyq
    zed
    vscode
    wemeet
  ];
}
