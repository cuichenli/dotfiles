{ pkgs, home-manager, ... }:

{
  home.username = "cuichen";
  home.homeDirectory = "/home/cuichen";

  home.file = {
    "/home/cuichen/.local/share/fcitx5/rime/default.custom.yaml".source =
      ../files/rime/default.custom.yaml;
    # "/home/cuichen/.config/fontconfig/conf.d/50-zh-cn-font.conf".source = 
    #   ../files/50-zh-cn-font.conf;
  };

  home.packages = with pkgs; [
    nerd-fonts.ubuntu-sans
    maple-mono.CN
  ];
}
