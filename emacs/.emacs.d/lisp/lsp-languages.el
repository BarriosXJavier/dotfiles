;;; lsp-languages.el --- LSP support for multiple languages -*- lexical-binding: t; -*-

;; Ensure Mason and cargo binaries are in exec-path
(use-package emacs
  :config
  (add-to-list 'exec-path (expand-file-name "~/.local/share/nvim/mason/bin"))
  (add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
  (setenv "PATH" (concat (expand-file-name "~/.local/share/nvim/mason/bin") ":"
                         (expand-file-name "~/.cargo/bin") ":"
                         (getenv "PATH"))))

;; Completion framework
(use-package company
  :demand
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("<tab>" . company-complete-selection)
              ("TAB" . company-complete-selection))
  :config
  (setq company-idle-delay 0.1              ;; Show suggestions quickly
        company-minimum-prefix-length 1     ;; Start completing after 1 char
        company-selection-wrap-around t
        company-tooltip-align-annotations t ;; Align annotations to the right
        company-backends '(company-capf))   ;; Use completion-at-point (LSP)
  (global-company-mode 1))                  ;; Enable globally

;; Icons for completion items
(use-package company-box
  :after (company nerd-icons)
  :hook (company-mode . company-box-mode)
  :config
  (setq company-box-enable-icon t
        company-box-icons-alist 'company-box-icons-nerd-icons
        company-box-max-candidates 50
        company-box-doc-enable t))

;; Auto-pair brackets, parens, quotes
(use-package emacs
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

;; Core LSP
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")    ;; optional LSP key prefix
  :config
  (setq lsp-enable-snippet t
        lsp-prefer-flymake nil        ;; use flycheck if installed
        lsp-headerline-breadcrumb-enable t
        ;; Better completion experience
        lsp-completion-provider :capf
        lsp-completion-show-detail t
        lsp-completion-show-kind t
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t
        ;; Performance tuning
        lsp-idle-delay 0.2
        lsp-log-io nil
        ;; Use existing LSP servers from Mason/system PATH
        lsp-rust-analyzer-server-command '("rust-analyzer")
        lsp-gopls-server-path "gopls"
        ;; Prevent automatic installation
        lsp-enable-suggest-server-download nil
        lsp-auto-guess-root t))

;; UI enhancements for LSP
(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-delay 0.3
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-show-with-cursor t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-peek-enable t
        lsp-ui-peek-always-show t))

;; Snippet support for better completions
(use-package yasnippet
  :demand
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;; Optional: ivy integration for workspace symbols
(use-package lsp-ivy
  :after lsp
  :commands lsp-ivy-workspace-symbol)

;; === Language-specific hooks ===

;; Python
(use-package python
  :hook (python-mode . lsp-deferred))

;; JavaScript / JSX
(use-package js
  :hook ((js-mode js2-mode) . lsp-deferred))

;; TypeScript / TSX
(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; Rust
(use-package rust-mode
  :hook (rust-mode . lsp-deferred)
  :config
  ;; Use LSP for checking, disable cargo checker
  (setq rust-format-on-save nil)
  (with-eval-after-load 'flycheck
    (setq-default flycheck-disabled-checkers '(rust-cargo rust-clippy))))

;; Go
(use-package go-mode
  :hook (go-mode . lsp-deferred))

;; C / C++
(use-package cc-mode
  :hook ((c-mode c++-mode) . lsp-deferred)
  :config
  (setq c-default-style "linux"
        c-basic-offset 2))


(provide 'lsp-languages)
;;; lsp-languages.el ends here

