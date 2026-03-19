{
  config,
  pkgs,
  ...
}:
{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
    ];

    extraPackages = with pkgs; [
      gcc
      gnumake
      tree-sitter
    ];
  };
}
