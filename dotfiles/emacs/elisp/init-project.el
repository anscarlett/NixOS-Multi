;;; init-project.el --- main core settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(define-key global-map (kbd "C-c p") project-prefix-map)

(use-package project
  :ensure nil
  :config
  ;; (setq project-switch-commands #'project-find-file)
  (setq project-switch-commands
        '((project-find-file "Find file" f)
          (project-dired "Dired" d)
          (project-vc-dir "VC-Dir" v)
          (project-shell "Shell" s)
          (project-eshell "Eshell" e)
          (magit-project-status "Magit" ?m)))
  )

;; Treemacs
(use-package treemacs
  :custom (setq treemacs-follow-after-init t
                treemacs-project-follow-mode t
                treemacs-git-commit-diff-mode t
                treemacs-file-follow-delay 2
                treemacs-show-cursor nil
                treemacs-silent-filewatch t
                treemacs-silent-refresh t)
  :bind (("<f1>" . treemacs)
         (:map treemacs-mode-map
               ("<mouse-1>" . treemacs-single-click-expand-action))))

;; Dashboard
(use-package dashboard
;; :diminish (dashboard-mode page-break-lines-mode)
  :custom
  (dashboard-startup-banner 2)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-set-footer nil)
  (dashboard-center-content t)
  (dashboard-projects-backend 'project-el)
  (dashboard-banner-logo-title nil) ; "Welcome to Emacs!"
  (dashboard-items  '((recents  . 12)
                      (bookmarks . 5)
                      (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; Persp-mode
(use-package persp-mode
  :init (setq persp-keymap-prefix (kbd "C-c w"))
  :config
  ;; (setq wg-morph-on nil) ;; switch off animation
  (setq persp-auto-resume-time 0)
  (add-hook 'after-init-hook #'(lambda () (persp-mode 1))))

;; Magit
(use-package magit
  :bind
  (("C-c g" . magit-status)
   ("s-g" . magit-status)))

;; git-gutter
(use-package git-gutter
  :diminish (git-gutter-mode)
  :custom
  (git-gutter:modified-sign  "~")
  (git-gutter:added-sign  "+")
  (git-gutter:deleted-sign  "-")
  :custom-face
  (git-gutter:modified  ((t (:background "#f1fa8c"))))
  (git-gutter:added  ((t (:background "#50fa7b"))))
  (git-gutter:deleted  ((t (:background "#ff79c6"))))
  :config
  (global-git-gutter-mode 1))

(use-package forge
  :after magit)

(use-package git-timemachine
  :bind (:map vc-prefix-map
              ("t" . git-timemachine)))

(use-package browse-at-remote
  :bind (:map vc-prefix-map
              ("o" . browse-at-remote)))

(use-package blamer
  :commands (blamer-mode))

(provide 'init-project)
;;; init-project.el ends here
