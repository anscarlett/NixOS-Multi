;;; init-packages.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:


(require 'package)

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

;; Initialize packages
(unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
  (setq package-enable-at-startup nil)          ; To prevent initializing twice
  (package-initialize))

;; ;; Bootstrap `use-package` remove after emacs 29
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

;; use-package setting
(setq use-package-always-ensure t
      ;; use-package-always-defer t
      ;; use-package-verbose t
      use-package-enable-imenu-support t)
(require 'use-package)

(require 'cl-lib)

;; (use-package dash)
(use-package s) ;string manipulation
(use-package f) ;file manipulation

(use-package bind-key)
(use-package diminish)
(diminish 'visual-line-mode)
(diminish 'eldoc-mode) ;echo area 显示函数的参数列表

;; Control use of local variables in files you visit.
;; :safe means set the safe variables, and ignore the rest.
(setq enable-local-variables :safe)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; Extensions ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
(use-package doom-themes)
;; (use-package ef-themes)
;; (use-package tangonov-theme)
;; (use-package monokai-theme)
;; (use-package vscode-dark-plus-theme)
;; (use-package zenburn)
;; (use-package eclipse-theme)
(load-theme 'doom-tomorrow-night t)
;; (load-theme 'ef-frost t)

(use-package nyan-mode
  :commands nyan-mode)

(use-package all-the-icons)

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)))

(use-package macrostep
  :bind (:map emacs-lisp-mode-map
         ("C-c e" . macrostep-expand)
         :map lisp-interaction-mode-map
         ("C-c e" . macrostep-expand)))

;; mwim ;moving to the beginning/end code
(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; (use-package mosey
;;   :bind (("C-a" . mosey-backward-bounce)
;;          ("C-e" . mosey-forward-bounce)))

;; move-text M-up/M-down
(use-package move-text
  :init
  (move-text-default-bindings))

(use-package iedit
  :defer t)

(use-package multiple-cursors
  :bind (("C-}" . mc/mark-next-like-this)
         ("C-{" . mc/mark-previous-like-this)
         ("C-|" . mc/mark-all-like-this-dwim)))

(use-package expand-region
  :bind (("C-=" . er/expand-region)
         ("C--" . er/contract-region)
         ("C-c m '" . er/mark-inside-quotes)
         ("C-c m [" . er/mark-inside-pairs)))

;; Smartly select region, rectangle, multi cursors
(use-package smart-region
  :commands smart-region-on
  :hook (after-init . smart-region-on))

(use-package anzu
  :bind
  ([remap query-replace] . anzu-query-replace)
  ([remap query-replace-regexp] . anzu-query-replace-regexp))

;; Writable grep buffer
(use-package wgrep
  :defer t)

(use-package hl-todo
  :config
  (global-hl-todo-mode))

;; 显示截断竖线
(use-package fill-column-indicator
  :commands fci-mode)

;; 高亮删除插入操作
;; (use-package volatile-highlights
;;   :config (volatile-highlights-mode t))

;; rainbow 颜色代码显色 #00FF00
(use-package rainbow-mode
  :commands rainbow-mode)

;; rainbow-delimiters  彩虹括号
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; same as beacon
(use-package scrollkeeper
  :bind
  (([remap scroll-up-command] . scrollkeeper-contents-up)
   ([remap scroll-down-command] . scrollkeeper-contents-down)))

;; (use-package beacon
;;   :custom
;;   (beacon-color "#aa3400")
;;   ;; (beacon-size  64)
;;   (beacon-blink-when-focused t)
;;   :custom-face
;;   (beacon-fallback-background ((t (:background "#556b2f"))))
;;   :config
;;   (beacon-mode 1))

;; Narrow/Widen
;; (use-package fancy-narrow
;;   :diminish fancy-narrow-mode
;;   :init
;;   (fancy-narrow-mode 1))

(use-package goto-last-change
  :bind (("C-c m l" . goto-last-change)))

;; Bookmark
(use-package bm
  :bind
  (("C-c m m" . bm-toggle)
   ;; ("C-c m p" . bm-previous)
   ;; ("C-c m n" . bm-next)
   ("C-c m 0" . bm-remove-all-current-buffer)))

;; avy
(use-package avy
  :bind (("M-s" . avy-goto-char)))

;; avy-zap
(use-package avy-zap
  :bind (("M-z" . avy-zap-up-to-char-dwim)))

;; ace-window
(use-package ace-window
  :bind
  (([remap other-window] . ace-window)
   ("C-x 4 x" . ace-swap-window)
   ("C-c w x" . ace-swap-window)))

;; rotate
(use-package rotate
  :bind (("C-c w v" . rotate-layout)))

(use-package ialign
  :bind (("C-x l" . ialign)))

(use-package fanyi
  :bind (("C-c y" . fanyi-dwim2)))

;; (use-package auto-sudoedit
;;   :delight
;;   :commands auto-sudoedit-sudoedit
;;   :init (defalias 'sudoedit #'auto-sudoedit-sudoedit))

(use-package doom-modeline
    :init (doom-modeline-mode 1)
    :custom ((doom-modeline-buffer-file-name-style 'relative-to-project)
             (doom-modeline-icon t)
             (doom-modeline-major-mode-icon t)
             (doom-modeline-major-mode-color-icon t)
             (line-number-mode 1)
             (column-number-mode 1)))

;; (use-package centaur-tabs
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
(use-package gcmh
  :diminish gcmh-mode
  :hook (emacs-startup . gcmh-mode)
  :init (setq gcmh-idle-delay 'auto
         gcmh-auto-idle-delay-factor  10
         gcmh-high-cons-threshold  16777216))

(use-package restart-emacs
  :commands restart-emacs)

(provide 'init-packages)
;;; init-packages.el ends here
