;;; init-project.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; deft
;; (leaf deft
;;   :bind (("<f8>" . deft))
;;   :config (setq deft-extensions '("md" "org" "txt")
;;                 deft-recursive t
;;                 deft-use-filename-as-title t))

;; Treemacs
(leaf treemacs
  :ensure t
  :setq ((treemacs-follow-after-init . t)
         (treemacs-project-follow-mode . t)
         (treemacs-git-commit-diff-mode . t)
         (treemacs-file-follow-delay . 2)
         (treemacs-show-cursor . nil)
         (treemacs-silent-filewatch . t)
         (treemacs-silent-refresh . t))
  :bind (("<f1>" . treemacs)
         (:treemacs-mode-map
          ("<mouse-1>" . treemacs-single-click-expand-action))))

;; (leaf neotree
;;   :ensure t
;;   :commands
;;   (neotree-show neotree-hide neotree-dir neotree-find)
;;   :custom (neo-theme . 'nerd2)
;;   :bind
;;   ("<f1>" . neotree-projectile-toggle))

;; (leaf sr-speedbar
;;   :ensure t
;;   :bind (("<f1>" . sr-speedbar-toggle))
;;   :config
;;   (setq speedbar-hide-button-brackets-flag t
;;         speedbar-show-unknown-files t
;;         speedbar-smart-directory-expand-flag t
;;         ;; speedbar-indentation-width 1
;;         speedbar-update-flag t
;;         ;; sr-speedbar-width 20
;;         ;; sr-speedbar-width-x 20
;;         sr-speedbar-auto-refresh t
;;         sr-speedbar-right-side nil
;;         sr-speedbar-skip-other-window-p t))

;; Magit
(leaf magit
  :ensure t
  :bind
  (("C-c g" . magit-status)
   ("s-g" . magit-status)
   ;; (:magit-status-mode-map
   ;;  ("p" . magit-push))
   ))

;; git-gutter
(leaf git-gutter
  :ensure t
  :custom ((git-gutter:modified-sign . "~")
           (git-gutter:added-sign . "+")
           (git-gutter:deleted-sign . "-"))
  :custom-face ((git-gutter:modified . '((t (:background "#f1fa8c"))))
                (git-gutter:added . '((t (:background "#50fa7b"))))
                (git-gutter:deleted . '((t (:background "#ff79c6")))))
  :config
  (global-git-gutter-mode 1))

(leaf forge
  :disabled t
  :after magit
  )

(leaf git-timemachine
  :ensure t
  :bind (("C-x v t" . git-timemachine-toggle)))

(leaf editorconfig
  :ensure t
  :diminish editorconfig-mode
  :custom
  (editorconfig-get-properties-function . 'editorconfig-core-get-properties-hash)
  :init
  (editorconfig-mode t))

;; Dashboard
(leaf dashboard
  :ensure t
  :blackout t
  :setq ((dashboard-startup-banner . 2)
         (dashboard-set-heading-icons . t)
         (dashboard-set-file-icons . t)
         (dashboard-set-footer . nil)
         (dashboard-center-content . t)
         (dashboard-projects-backend . 'project-el)
         (dashboard-banner-logo-title . nil) ; "Welcome to Emacs!"
         (dashboard-items . '((recents  . 12)
                              (bookmarks . 5)
                              (projects . 5))))
  :config
  (dashboard-setup-startup-hook))

;; Persp-mode
(leaf persp-mode
  :ensure t
  :init (setq persp-keymap-prefix (kbd "C-c w"))
  :setq ((persp-auto-resume-time . 0))
  :hook (after-init-hook . persp-mode))

;; Projectile
;; (use-package projectile
;;   :diminish projectile-mode
;;   :commands projectile-mode
;;   ;; :bind-keymap ("s-p" . projectile-command-map)
;;   :init (setq projectile-require-project-root nil) ; make projectile usable for every directory
;;   :config
;;   (progn
;;     (projectile-mode 1)
;;     (setq projectile-completion-system 'ivy)
;;     (setq projectile-switch-project-action #'projectile-dired)))

(provide 'init-project)
;;; init-project.el ends here
