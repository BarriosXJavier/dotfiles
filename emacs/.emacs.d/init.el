(tool-bar-mode -1)             ; Hide the outdated icons
(scroll-bar-mode -1)           ; Hide the always-visible scrollbar
(menu-bar-mode -1)             ; Hide the menu bar
(setq inhibit-splash-screen t) ; Remove the "Welcome to GNU Emacs" splash screen
(setq use-file-dialog nil)     ; Ask for textual confirmation instead of GUI
(setq frame-resize-pixelwise t) ; Allow pixel-level resizing
(add-to-list 'default-frame-alist '(undecorated . t)) ; Remove title bar

(defvar bootstrap-version)
(let ((bootstrap-file
    (expand-file-name
      "straight/repos/straight.el/bootstrap.el"
      (or (bound-and-true-p straight-base-dir)
        user-emacs-directory)))
    (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
       'silent 'inhibit-cookies)
    (goto-char (point-max))
    (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Syntax: (set-frame-font "FONT-NAME-SIZE" KEEP-SIZE ALL-FRAMES)
(set-frame-font "JetbrainsMono Nerd Font-12" nil t)

(setq package-enable-at-startup nil)

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)
(setq straight-check-for-modifications '(check-on-save find-when-checking))
(setq use-package-always-defer t)

(use-package emacs
  :init
  (setq initial-scratch-message nil)
  (defun display-startup-echo-area-message ()
    (message "")))

(use-package emacs
  :init
  (defalias 'yes-or-no-p 'y-or-n-p))

(use-package emacs
  :init
  (set-charset-priority 'unicode)
  (setq locale-coding-system 'utf-8
        coding-system-for-read 'utf-8
        coding-system-for-write 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (prefer-coding-system 'utf-8)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix)))

(use-package emacs
  :init
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 2)
  ;; Better RET behavior: indent new line automatically
  (electric-indent-mode 1)
  ;; Disable backup files (like Vim's .swp files)
  (setq make-backup-files nil
        auto-save-default nil
        create-lockfiles nil)
  ;; Better scrolling
  (setq scroll-margin 3
        scroll-conservatively 101
        scroll-preserve-screen-position t)
  ;; Smooth mouse scrolling
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
        mouse-wheel-progressive-speed nil))


(use-package doom-themes
  :demand
  :config
  (load-theme 'doom-challenger-deep t))

(use-package emacs
  :init
  (defun ab/enable-line-numbers ()
    "Enable relative line numbers"
    (interactive)
    (display-line-numbers-mode)
    (setq display-line-numbers 'relative))
  (add-hook 'prog-mode-hook #'ab/enable-line-numbers))

(use-package nerd-icons
  :demand)

(use-package doom-modeline
  :ensure t
  :after nerd-icons
  :init
  (setq doom-modeline-icon t)
  :hook
  (after-init . doom-modeline-mode))

;; which-key: shows available keybindings in popup
(use-package which-key
  :demand
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.25))

;; Magit: Git interface
(use-package magit
  :bind ("C-x g" . magit-status))

;; Projectile: Project management
(use-package projectile
  :demand
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/projects" "~/dotfiles")))

;; Ivy/Counsel: Fuzzy finding and completion
(use-package ivy
  :demand
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "
        enable-recursive-minibuffers t))

(use-package counsel
  :demand
  :bind (("C-s" . swiper)
         ("C-x C-f" . counsel-find-file)
         ("C-x b" . counsel-switch-buffer)
         ("M-x" . counsel-M-x))
  :config
  (counsel-mode 1))

(use-package ivy-rich
  :after ivy
  :demand
  :config
  (ivy-rich-mode 1))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; Flycheck: Syntax checking
(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; Git gutter: Show git diff in margin
(use-package git-gutter
  :demand
  :config
  (global-git-gutter-mode +1)
  (setq git-gutter:update-interval 0.5))

;; Rainbow delimiters: Colorize matching parentheses
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Treemacs: File explorer sidebar
(use-package treemacs
  :bind (("C-x t t" . treemacs)
         ("C-x t 1" . treemacs-select-window))
  :config
  (setq treemacs-width 30
        treemacs-follow-mode t
        treemacs-filewatch-mode t
        treemacs-is-never-other-window t))

(use-package treemacs-nerd-icons
  :after (treemacs nerd-icons)
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

;; vterm: Fast terminal emulator
(use-package vterm
  :bind ("C-c t" . vterm))

;; Emmet: HTML/CSS abbreviation expansion
(use-package emmet-mode
  :hook ((html-mode css-mode sgml-mode web-mode typescript-mode) . emmet-mode)
  :config
  (setq emmet-move-cursor-between-quotes t))


(add-to-list 'load-path (file-name-concat user-emacs-directory "lisp"))
(require 'lsp-languages)
