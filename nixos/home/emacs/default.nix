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
      epkgs.just-ts-mode
      epkgs.treesit-grammars.with-all-grammars
      epkgs.treesit-auto
    ];
    extraConfig = ''
      (menu-bar-mode -1)
      (tool-bar-mode -1)
      (scroll-bar-mode -1)
      (tooltip-mode -1)

      (custom-set-variables
        '(inhibit-startup-screen t))
      (setq initial-scratch-message "")
      (setq ring-bell-function 'ignore)

      (customize-set-variable 'indent-tabs-mode nil)
      (customize-set-variable 'tab-width 4)
      (show-paren-mode 1)

      (setq-default cursor-type 'bar)

      (fset 'yes-or-no-p 'y-or-n-p)

      (use-package no-littering
        :config
        (no-littering-theme-backups)
        (setq custom-file (make-temp-file "custom.el")))

      (use-package ef-themes
        :init
        (load-theme 'ef-maris-dark t))
      (add-to-list 'default-frame-alist '(alpha-background . 70))

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

      (use-package treesit-auto
        :config
        (treesit-auto-add-to-auto-mode-alist 'all)
        (global-treesit-auto-mode)
        (setq treesit-font-lock-level 4))
    '';
  };
}
