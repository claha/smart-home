{ config, lib, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.ef-themes
      epkgs.prescient
      epkgs.vertico
      epkgs.vertico-prescient
      epkgs.nix-ts-mode
      (epkgs.treesit-grammars.with-grammars (ts: [
        ts.tree-sitter-nix
      ]))
    ];
    extraConfig = ''
    (use-package ef-themes
      :init
      (load-theme 'ef-maris-dark t))

    (use-package savehist
      :init
      (savehist-mode))

    (use-package prescient
      :config
      (prescient-persist-mode))

    (use-package vertico
      :init
      (vertico-mode))

    (use-package vertico-prescient
      :after vertico prescient
      :init
      (vertico-prescient-mode))

    (use-package nix-ts-mode
      :mode "\\.nix\\'")
    '';
  };
}
