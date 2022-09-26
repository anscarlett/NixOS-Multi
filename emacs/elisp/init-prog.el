;;; init-prog.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; prog-mode 编程模式设定
(defun my-prog-settings ()
  "My owner my-prog-settings."
  (hl-line-mode)               ;高亮当前行
  (whitespace-mode)            ;显示空格
  (display-line-numbers-mode)) ;显示行号
(add-hook 'prog-mode-hook 'my-prog-settings)

;; conf-mode
(add-to-list 'auto-mode-alist
             '("bashrc\\'" . conf-mode))
(global-set-key [remap conf-space-keywords] #'project-find-file)

;; compilation
(setq compilation-ask-about-save nil  ;Just save before compiling
      compilation-always-kill t       ;kill old compile processes before new one
      compilation-scroll-output 'first-error ; Automatically scroll to first error
      )

;; tree-sitter
;; need github connect download
(leaf tree-sitter
  :ensure tree-sitter-langs
  :diminish tree-sitter-mode
  :commands global-tree-sitter-mode tree-sitter-hl-mode
  :hook ((after-init-hook . global-tree-sitter-mode)
         (tree-sitter-after-on-hook . tree-sitter-hl-mode)))

;; Markdown
(leaf markdown-mode
  :ensure t
  :after t
  :custom
  (markdown-hide-urls . nil)
  (markdown-fontify-code-blocks-natively . t)
  :mode (("\\.md\\'" . gfm-mode)
         ("README\\'" . gfm-mode)))

;; SQL
(leaf sql-indent
  :ensure t
  :mode ("\\.sql\\'")
  :interpreter (("sql" . sql-mode)))

;; docker
(leaf dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'"))

;; toml
(leaf toml-mode
  :ensure t
  :mode ("\\.toml'"))

;; yaml
(leaf yaml-mode
  :ensure t
  :mode ("\\.yml'"))

;; nixos
(leaf nix-mode
  :ensure t
  :mode ("\\.nix'"))

(leaf nixpkgs-fmt
  :ensure t)

;; lua
(leaf lua-mode
  :ensure t
  :mode ("\\.lua'"))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Company, fly, yas, lsp ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; corfu
(leaf corfu
  :ensure t
  :bind ((corfu-map
          ("<escape>" . corfu-quit)))
  :hook (prog-mode-hook)
  :config
  (let ((custom--inhibit-theme-enable nil))
    (unless (memq 'use-package custom-known-themes)
      (deftheme use-package)
      (enable-theme 'use-package)
      (setq custom-enabled-themes (remq 'use-package custom-enabled-themes)))
    (custom-theme-set-variables 'use-package
                                '(corfu-auto t nil nil "Customized with use-package corfu")))
  (global-corfu-mode))

;; company
;; (use-package company
;;   :defer t
;;   :diminish company-mode
;;   :hook (prog-mode . company-mode)
;;   :config (setq company-tooltip-align-annotations t)
;;   (setq company-minimum-prefix-length 1)
;;   ;; Trigger completion immediately.
;;   (setq company-idle-delay 0)
;;   ;; Number the candidates (use M-1, M-2 etc to select completions).
;;   (setq company-show-numbers t))

;; (with-eval-after-load 'company
;;     (setq-default company-dabbrev-other-buffers 'all
;;                   company-tooltip-align-annotations t)
;;     (define-key company-mode-map (kbd "C-.") 'company-complete)
;;     (define-key company-mode-map [remap completion-at-point] 'company-complete)
;;     (define-key company-mode-map [remap indent-for-tab-command] 'company-indent-or-complete-common)
;;     (define-key company-active-map (kbd "C-.") 'company-other-backend))

;; tabnine
;; ;; M-x company-tabnine-install-binary
;; (use-package company-tabnine)
;; (add-to-list 'company-backends #'company-tabnine)

;; flycheck
(leaf flycheck
  :ensure t
  :hook (prog-mode-hook)
  :config
  (with-eval-after-load 'flycheck
    (setq flycheck-emacs-lisp-load-path 'inherit)
    (if (fboundp 'diminish)
        (diminish 'flycheck-mode))))

;; yasnippet
(leaf yasnippet
  :ensure t
  :hook ((prog-mode-hook . yas-minor-mode))
  :config
  (with-eval-after-load 'yasnippet
    (yas-reload-all)
    (if (fboundp 'diminish)
        (diminish 'yas-minor-mode))))
(leaf yasnippet-snippets
  :ensure t
  :config
  (with-eval-after-load 'yasnippet
    (require 'yasnippet-snippets nil nil)
    (yasnippet-snippets-initialize)))

;; LSP https://emacs-lsp.github.io/lsp-mode/
;; (leaf lsp-mode
;;   :ensure t
;;   :commands lsp-deferred lsp
;;   :hook ((python-mode-hook . lsp-deferred)
;;          (rust-mode-hook . lsp-deferred)))

;; (leaf lsp-ui
;;   :ensure t
;;   :commands lsp-ui-mode)
;; (leaf lsp-ivy
;;   :ensure t
;;   :commands lsp-ivy-workspace-symbol)


;; eglot
(leaf eglot
  :ensure t
  :require t
  :config
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'ruby-mode-hook 'eglot-ensure)
  (add-hook 'markdown-mode-hook 'eglot-ensure)
  (add-hook 'go-mode-hook 'eglot-ensure))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               `(markdown-mode . ("efm-langserver"))))

(leaf consult-lsp
  :ensure t
  :package t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Rust ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rustic https://github.com/brotzeit/rustic
(leaf rustic
  :ensure t
  :mode "\\.rs$"
  :custom
  (rustic-format-display-method . 'ignore) ; Rustfmtのメッセージをポップアップしない
  (rustic-format-trigger . 'on-save)
  :after flycheck
  :defvar flycheck-checkers
  :config
  (push 'rustic-clippy flycheck-checkers))

;; (use-package rust-mode
;;   :mode "\\.rs\\'"
;;   ;; :hook (rust-mode . lsp)
;;   :config
;;   (setq rust-format-on-save t))

;; (use-package cargo
;;   :defer t
;;   :hook (rust-mode . cargo-minor-mode))

;; (use-package flycheck-rust
;;   :defer t
;;   ;; :config
;;   ;; (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
;;   )
;; (with-eval-after-load 'rust-mode
;;   (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

;; (leaf go-mode
;;   :ensure t
;;   :commands go-mode
;;   :config
;;   (setq gofmt-command "goimports")
;;   (add-hook 'before-save-hook 'gofmt-before-save))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(leaf python-mode
  :ensure t
  :mode ("\\.py\\'")
  :config
  (with-eval-after-load 'python-mode
    (setq python-indent-offset 4
          python-indent 4
          indent-tabs-mode nil
          default-tab-width 4
          python-shell-interpreter "python3")))

;; (use-package lsp-python-ms
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-python-ms)
;;                           (lsp))))
                                        ; or lsp-deferred

;;; Ruby
;; (leaf ruby-mode
;;   :defvar ruby-mode-map
;;   :custom (ruby-insert-encoding-magic-comment . nil)
;;   :hook (ruby-mode-hook . lsp)
;;   :config
;;   (dvorak-set-key-prog ruby-mode-map)
;;   (leaf inf-ruby
;;     :ensure t
;;     :hook (ruby-mode-hook . inf-ruby-minor-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;; Common lisp ;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; elisp-mode
;; (defun no-fly-yas()
;;   "No fly anf yas."
;;   (flycheck-mode -1) (yas-minor-mode -1))
;; (add-hook 'emacs-lisp-mode-hook 'no-fly-yas)
(add-hook 'emacs-lisp-mode-hook (lambda () (flycheck-mode -1)) t) ;only flycheck
(add-hook 'emacs-lisp-mode-hook (lambda () (setq mode-name "ξ "))) ;hook for shortname


(provide 'init-prog)
;;; init-prog.el ends here
