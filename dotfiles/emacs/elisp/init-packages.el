;;; init-packages.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; setup leaf
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; (leaf feather
;;   :el-get conao3/feather.el
;;   :config (feather-mode))

(leaf leaf
  :config
  ;; (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

;; string manipulation
;; (leaf s
;;   :ensure t
;;   :require t)

;; ;; file manipulation
;; (leaf f
;;   :ensure t
;;   :require t)

;; (use-package bind-key)
(leaf diminish
  :ensure t
  :require t)

(diminish 'visual-line-mode)
(diminish 'eldoc-mode) ;echo area 显示函数的参数列表

;; Control use of local variables in files you visit.
;; :safe means set the safe variables, and ignore the rest.
(setq enable-local-variables :safe)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Extensions ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
(leaf doom-themes
  :ensure t)
;; (leaf ef-themes
;;   :ensure t)
;; (leaf tangonov-theme
;;   :ensure t
;;   :require t)
;; (leaf monokai-theme
;;   :require t)
;; (leaf vscode-dark-plus-theme
;;   :require t)
;; (leaf zenburn
;;   :require t)
;; (leaf eclipse-theme
;;   :require t)
(load-theme 'doom-tomorrow-night t)
;; (load-theme 'ef-frost t)

(leaf all-the-icons
  :ensure t)

(leaf which-key
  :ensure t
  :diminish which-key-mode
  :hook (after-init-hook . which-key-mode))

(leaf helpful
  :ensure t
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

;; mwim ;moving to the beginning/end code
(leaf mwim
  :ensure t
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; (leaf mosey
;;   :ensure t
;;   :bind (("C-a" . mosey-backward-bounce)
;;          ("C-e" . mosey-forward-bounce)))


;; move-text M-up/M-down
(leaf move-text
  :ensure t
  :init
  (move-text-default-bindings))

(leaf iedit
  :ensure t)

(leaf multiple-cursors
  :ensure t
  :bind (("C-}" . mc/mark-next-like-this)
         ("C-{" . mc/mark-previous-like-this)
         ("C-|" . mc/mark-all-like-this-dwim)))

(leaf expand-region
  :ensure t
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)
         ("C-c m '" . er/mark-inside-quotes)
         ("C-c m [" . er/mark-inside-pairs)))

;; Smartly select region, rectangle, multi cursors
(leaf smart-region
  :ensure t
  :commands smart-region-on
  :hook ((after-init-hook . smart-region-on)))

(leaf anzu
  :ensure t
  :custom (global-anzu-mode . t)
  :bind
  ([remap query-replace] . anzu-query-replace)
  ([remap query-replace-regexp] . anzu-query-replace-regexp))

(leaf wgrep
  :ensure t)

(leaf hl-todo
  :ensure t
  :config
  (global-hl-todo-mode))

;; 显示截断竖线
(leaf fill-column-indicator
  :ensure t
  :commands fci-mode)

;; 高亮删除插入操作
;; (leaf volatile-highlights
;;   :ensure t
;;   :config (volatile-highlights-mode t))

;; rainbow 颜色代码显色 #00FF00
(leaf rainbow-mode
  :ensure t
  :commands rainbow-mode)

;; rainbow-delimiters  彩虹括号
(leaf rainbow-delimiters
  :ensure t
  :blackout t
  :hook (prog-mode-hook))

;; same as beacon
(leaf scrollkeeper
  :ensure t
  :bind
  (([remap scroll-up-command] . scrollkeeper-contents-up)
   ([remap scroll-down-command] . scrollkeeper-contents-down)))

;; (leaf beacon
;;   :ensure t
;;   :blackout t
;;   :hook (prog-mode-hook)
;;   :custom ((beacon-color . "#77fffa")
;;            (beacon-blink-duration . 0.7)
;;            (beacon-size . 100)))

;; Narrow/Widen
(leaf fancy-narrow
  :ensure t
  :diminish fancy-narrow-mode
  :init
  (fancy-narrow-mode 1))

(leaf goto-last-change
  :ensure t
  :bind (("C-c m l" . goto-last-change)))

;; Bookmark
(leaf bm
  :ensure t
  :bind
  (("C-c m m" . bm-toggle)
   ;; ("C-c m p" . bm-previous)
   ;; ("C-c m n" . bm-next)
   ("C-c m 0" . bm-remove-all-current-buffer)))

;; avy
(leaf avy
  :ensure t
  :bind (("M-s" . avy-goto-char)))

;; avy-zap
(leaf avy-zap
  :ensure t
  :bind (("M-z" . avy-zap-up-to-char-dwim)))

;; ace-window
(leaf ace-window
  :ensure t
  :bind
  (([remap other-window] . ace-window)
   ("C-x 4 x" . ace-swap-window)
   ("C-c w x" . ace-swap-window)))

;; rotate
(leaf rotate
  :ensure t
  :bind (("C-c w v" . rotate-layout)))

(leaf ialign
  :ensure t
  :bind (("C-x l" . ialign)))

(leaf fanyi
  :ensure t
  :bind (("C-c y" . fanyi-dwim2)))

;; (leaf auto-sudoedit
;;   :ensure t
;;   :blackout t
;;   :hook (after-init-hook))

(leaf doom-modeline
    :ensure t
    :hook (after-init-hook)
    :custom ((doom-modeline-buffer-file-name-style quote relative-to-project)
             (doom-modeline-icon . t)
             (doom-modeline-major-mode-icon . t)
             (doom-modeline-major-mode-color-icon . t)
             (line-number-mode . 1)
             (column-number-mode . 1)))

;; (leaf centaur-tabs
;;   :ensure t
;;   :custom ((centaur-tabs-height . 28)
;;            (centaur-tabs-style . "wave")
;;            (centaur-tabs-set-icons . t)
;;            (centaur-tabs-set-bar . 'over)
;;            (centaur-tabs-set-close-button . nil)
;;            (centaur-tabs-set-modified-marker . t)
;;            (centaur-tabs-modified-marker . "●"))
;;   :config
;;   (centaur-tabs-mode t))

;; Garbage Collector Magic Hack
(leaf gcmh
  :ensure t
  :diminish gcmh-mode
  :hook (emacs-startup-hook)
  :setq ((gcmh-idle-delay quote auto)
         (gcmh-auto-idle-delay-factor . 10)
         (gcmh-high-cons-threshold . 16777216)))

(provide 'init-packages)
;;; init-packages.el ends here
