;;; ~/.emacs.d/init.el --- Initialize -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Speed up startup
(setq auto-mode-case-fold nil)

;; Load Path
;; (defvar my-dir (concat user-emacs-directory "elisp"))
;; (add-to-list 'load-path my-dir)
(add-to-list 'load-path (expand-file-name "elisp" user-emacs-directory))

;; Backup files
(defconst my-backup (expand-file-name "my-backup" user-emacs-directory))
(unless (file-exists-p my-backup)
  (make-directory my-backup))

;; Temp files (save-place, recenf, undo-tree)
(defconst my-temp (expand-file-name "my-temp" user-emacs-directory))
(unless (file-exists-p my-temp)
  (make-directory my-temp))

;; Split emacs auto customizations
;; (setq custom-file (expand-file-name ".custom.el" user-emacs-directory))
;; (when (file-exists-p custom-file)
;;   (load custom-file 'noerror))

(eval-when-compile (require 'cl-lib nil t))

(require 'init-packages)
(require 'init-config)
(require 'init-functions)

(require 'init-backup)
(require 'init-dired)
(require 'init-shell)
(require 'init-vertico)
(require 'init-project)
(require 'init-keybindings)

(require 'lang-main)
(require 'lang-org)
(require 'lang-web)
;; (require 'lang-c-cpp-java)


;;; init.el ends here
