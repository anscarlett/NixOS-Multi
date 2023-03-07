;;; lang-programs.el --- Main Development languages -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; prog-mode 编程模式设定
(defun my-prog-settings ()
  "My owner my-prog-settings."
  (hl-line-mode)               ;高亮当前行
  (whitespace-mode)            ;显示空格
  (display-line-numbers-mode)) ;显示行号
(add-hook 'prog-mode-hook 'my-prog-settings)

(use-package reformatter
  :defer t
  :config
  (reformatter-define nix-alejandra
    :program "alejandra"
    ;; :args '("--" "quiet")
    )
  ;; Experimental.
  ;; (reformatter-define golint
  ;;   :program "golint"
  ;;   :stdin nil
  ;;   :stdout nil
  ;;   :args (list (buffer-file-name)))
  )

;; tree-sitter
(use-package treesit-auto
  :hook (after-init . global-treesit-auto-mode)
  :init (setq treesit-auto-install 'prompt))

;; conf-mode
(use-package conf-mode
  :mode
  "/credentials$" "\\.accept_keywords$"
  "\\lfrc$" "\\.keywords$" "\\.license$"
  "\\.mask$" "\\.unmask$" "\\.use$")
(global-set-key [remap conf-space-keywords] #'project-find-file)

;; compilation
(setq compilation-ask-about-save nil  ;Just save before compiling
      compilation-always-kill t       ;kill old compile processes before new one
      compilation-scroll-output 'first-error ; Automatically scroll to first error
      )

(use-package quickrun
  :defer t)

(use-package editorconfig
  :diminish editorconfig-mode
  :custom
  (editorconfig-get-properties-function  'editorconfig-core-get-properties-hash)
  :init
  (editorconfig-mode t))

;; Markdown
(use-package markdown-mode
  :config
  (setq markdown-hide-urls nil
        markdown-fontify-code-blocks-natively t)
  :mode (("\\.md\\'" . gfm-mode)
         ("README\\'" . gfm-mode)))
(use-package markdown-preview-mode
  :defer t)

;; SQL
(use-package sql-indent
  :mode ("\\.sql\\'")
  :interpreter (("sql" . sql-mode)))

;; docker
(use-package dockerfile-mode
  :mode ("Dockerfile\\'"))

;; json
(use-package json-mode
  :mode ("\\.json'"))

(use-package json-reformat
  :commands json-reformat-region)

;; toml
(use-package toml-mode
  :mode ("\\.toml'"))

;; yaml
(use-package yaml-mode
  :mode ("\\.yml'" "\\.yaml'"))

;; nixos
(use-package nix-mode
  :mode ("\\.nix'"))

(use-package nixpkgs-fmt
  :defer t)

;; lua
(use-package lua-mode
  :mode ("\\.lua'"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Company, fly, yas, lsp ;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; corfu
(use-package corfu
  :hook
  (emacs-startup . global-corfu-mode)
  :bind
  (:map corfu-map
   ("C-j"      . corfu-next)
   ("C-k"      . corfu-previous)
   ("C-g"      . corfu-quit)
   ("M-l"      . corfu-show-location)
   ("M-SPC" . corfu-insert-separator)
   ("<escape>" . corfu-quit)
   ("<return>" . corfu-insert)
   ("TAB" . corfu-insert)
   ([tab] . corfu-insert))
  :custom
  ;; auto-complete
  (corfu-auto t)
  (corfu-min-width 25)
  (corfu-max-width 90)
  (corfu-count 10)
  (corfu-scroll-margin 4)
  (corfu-cycle t)
  ;; TAB cycle if there are only few candidates
  (completion-cycle-threshold 3)
  (corfu-echo-documentation nil) ;; use corfu doc
  (corfu-separator  ?_)
  (corfu-quit-no-match 'separator)
  (corfu-quit-at-boundary t)
  (corfu-preview-current nil)       ; Preview current candidate?
  (corfu-preselect-first t)           ; Preselect first candidate?
  :config
  ;; Enable Corfu completion for commands like M-: (eval-expression) or M-!
  ;; (shell-command)
  (defun corfu-enable-in-minibuffer ()
    "Enable Corfu in the minibuffer if `completion-at-point' is bound."
    (when (where-is-internal #'completion-at-point (list (current-local-map)))
      ;; (setq-local corfu-auto nil) Enable/disable auto completion
      (corfu-mode 1)))
  (add-hook 'minibuffer-setup-hook #'corfu-enable-in-minibuffer))
;; (use-package corfu
;;   :init
;;   (setq corfu-auto t
;;         corfu-quit-no-match t
;;         corfu-quit-at-boundary 'separator)
;;   (global-corfu-mode)
;;   :config
;;   (define-key corfu-map
;;               (kbd "SPC") #'corfu-insert-separator)
;;   (setq completion-cycle-threshold 3)
;;   ;; Use Corfu in `eval-expression' and other commands that bind
;;   ;; `completion-at-point' in the minibuffer.
;;   ;;
;;   ;; WHY IS THIS NOT AVAILABLE IN AN OPTION IF IT'S ALREADY LISTED IN
;;   ;; THE README
;;   (add-hook 'minibuffer-setup-hook (lambda ()
;;                                      (when (memq #'completion-at-point
;;                                                  (flatten-tree
;;                                                   (current-local-map)))
;;                                        (corfu-mode)))))

;; Corfu Extensions
(use-package cape
  ;; Available: cape-file cape-dabbrev cape-history cape-keyword
  ;; cape-tex cape-sgml cape-rfc1345 cape-abbrev cape-ispell
  ;; cape-dict cape-symbol cape-line
  :init
  (add-to-list 'completion-at-point-functions #'cape-tex)
  (add-to-list 'completion-at-point-functions #'cape-keyword)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  (add-to-list 'completion-at-point-functions #'cape-ispell)
;; (add-to-list 'completion-at-point-functions #'cape-dict)
;; (add-to-list 'completion-at-point-functions #'cape-line)
;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev 90)
  (add-hook 'prog-mode-hook
            (lambda ()
              (add-hook 'completion-at-point-functions
                        #'cape-keyword nil t))))
  ;; :config
  ;; (require 'company)
  ;; (cl-loop for backend in '(company-glsl company-shell company-ledger)
  ;;          do (add-hook 'completion-at-point-functions
;;                       (cape-company-to-capf backend)))

;; TODO
;; (use-package kind-icon
;;   :after corfu
;;   :ini
;;   :custom
;;   (kind-icon-use-icons t)
;;   (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
;;   (kind-icon-blend-background nil))

;; company
;; (use-package company
;;   :use-package-defer nil
;;   :setq ((company-idle-delay . 0)
;;          (company-minimum-prefix-length . 1)
;;          (company-backends . '((company-dabbrev-code :separate company-capf company-keywords)
;;                                company-capf
;;                                company-files
;;                                company-keywords
;;                                company-yasnippet
;;                                company-abbrev))
;;          (company-echo-truncate-lines . t)
;;          (company-tooltip-align-annotations . t)
;;          (company-tng-auto-configure . t)
;;          (company-abort-on-unique-match . nil))
;;   :config (progn (global-company-mode t)))

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
(use-package flycheck
  :defer t
  :diminish (flycheck-mode)
  :hook (prog-mode . flycheck-mode))

;; tempel

;; yasnippet
;; (use-package yasnippet
;;   :hook (((prog-mode-hook org-mode-hook) . yas-minor-mode-on)
;;          (yas-minor-mode-hook . yas-reload-all)))


;; LSP https://emacs-lsp.github.io/lsp-mode/
;; (use-package lsp-mode
;;   :commands lsp-deferred lsp
;;   :hook ((python-mode-hook . lsp-deferred)
;;          (rust-mode-hook . lsp-deferred)))

;; (use-package lsp-ui
;;   :commands lsp-ui-mode)
;; (use-package lsp-ivy
;;   :commands lsp-ivy-workspace-symbol)

;; (use-package consult-lsp
;;   :package t)


;; eglot
(use-package eglot
  :defer t
  :config
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'ruby-mode-hook 'eglot-ensure)

  (add-to-list 'eglot-server-programs '(rust-mode . ("rust-analyzer")))
  (add-hook 'rust-mode-hook 'eglot-ensure)

  ;; (add-to-list 'eglot-server-programs '(nix-mode . ("nil")))
  ;; (add-hook 'nix-mode-hook 'eglot-ensure)

  (add-to-list 'eglot-server-programs `(markdown-mode . ("efm-langserver")))
  (add-hook 'markdown-mode-hook 'eglot-ensure)

  (add-to-list 'eglot-server-programs '(go-mode . ("gopls")))
  (add-hook 'go-mode-hook 'eglot-ensure))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Rust ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; rustic https://github.com/brotzeit/rustic
(use-package rustic
  :mode "\\.rs$"
  :custom
  (rustic-format-display-method 'ignore) ; Rustfmtのメッセージをポップアップしない
  (rustic-format-trigger 'on-save)
  :after flycheck
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

;; (use-package go-mode
;;   :commands go-mode
;;   :config
;;   (setq gofmt-command "goimports")
;;   (add-hook 'before-save-hook 'gofmt-before-save))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Python ;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package python-mode
  :mode ("\\.py\\'")
  :config
  (with-eval-after-load 'python-mode
    (setq python-indent-offset 4
          python-indent 4
          indent-tabs-mode nil
          default-tab-width 4
          python-shell-interpreter "python3")))

 ;; (use-package live-py-mode)

;; (use-package lsp-python-ms
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-python-ms)
;;                           (lsp))))
                                        ; or lsp-deferred

;;; Ruby
;; (use-package ruby-mode
;;   :defvar ruby-mode-map
;;   :custom (ruby-insert-encoding-magic-comment . nil)
;;   :hook (ruby-mode-hook . lsp)
;;   :config
;;   (dvorak-set-key-prog ruby-mode-map)
;;   (use-package inf-ruby
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


;; (use-package lsp-mode
;;   :require t
;;   :commands lsp
;;   :hook
;;   (go-mode-hook . lsp)
;;   (web-mode-hook . lsp)
;;   (elixir-mode-hook . lsp)
;;   (typescript-mode-hook . lsp)
;;   :config
;;   (use-package lsp-ui
;;     :require t
;;     :hook
;;     (lsp-mode-hook . lsp-ui-mode)
;;     :custom
;;     (lsp-ui-sideline-enable . nil)
;;     (lsp-prefer-flymake . nil)
;;     (lsp-print-performance . t)
;;     :config
;;     (define-key lsp-ui-mode-map [remap xref-find-definitions] 'lsp-ui-peek-find-definitions)
;;     (define-key lsp-ui-mode-map [remap xref-find-references] 'lsp-ui-peek-find-references)
;;     (define-key lsp-ui-mode-map (kbd "C-c i") 'lsp-ui-imenu)
;;     (define-key lsp-ui-mode-map (kbd "s-l") 'hydra-lsp/body)
;;     (setq lsp-ui-doc-position 'bottom)
;;     :hydra (hydra-lsp (:exit t :hint nil)
;;                       "
;;  Buffer^^               Server^^                   Symbol
;; -------------------------------------------------------------------------------------
;;  [_f_] format           [_M-r_] restart            [_d_] declaration  [_i_] implementation  [_o_] documentation
;;  [_m_] imenu            [_S_]   shutdown           [_D_] definition   [_t_] type            [_r_] rename
;;  [_x_] execute action   [_M-s_] describe session   [_R_] references   [_s_] signature"
;;                       ("d" lsp-find-declaration)
;;                       ("D" lsp-ui-peek-find-definitions)
;;                       ("R" lsp-ui-peek-find-references)
;;                       ("i" lsp-ui-peek-find-implementation)
;;                       ("t" lsp-find-type-definition)
;;                       ("s" lsp-signature-help)
;;                       ("o" lsp-describe-thing-at-point)
;;                       ("r" lsp-rename)

;;                       ("f" lsp-format-buffer)
;;                       ("m" lsp-ui-imenu)
;;                       ("x" lsp-execute-code-action)

;;                       ("M-s" lsp-describe-session)
;;                       ("M-r" lsp-restart-workspace)
;;                       ("S" lsp-shutdown-workspace))))


(provide 'lang-programs)
;;; init-main.el ends here
