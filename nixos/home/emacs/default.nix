{ config, lib, pkgs, ... }:
{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      epkgs.no-littering
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
      (setq ring-bell-function 'ignore)

      (setq inhibit-splash-screen t)
      (setq inhibit-startup-screen t)
      (setq inhibit-startup-buffer-menu t)
      (setq initial-scratch-message nil)
      (setq initial-buffer-choice nil)

      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (tooltip-mode -1)

      (setq indent-tabs-mode nil)
      (setq tab-width 4)

      (use-package no-littering
        :config
        (no-littering-theme-backups)
        (setq custom-file (make-temp-file "custom.el")))

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
