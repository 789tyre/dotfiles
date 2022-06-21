(setq inhibit-startup-message t)
(put 'dired-find-alternate-file 'disabled nil)
(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1) ; Disable the toolbar
(menu-bar-mode -1) ; Disable the menubar
(set-fringe-mode 10) ; Breathing room
(show-paren-mode t) ; Show matching brackets
(setq show-paran-style 'expression)
(setq-default indent-tabs-mode nil)
(setq display-line-numbers-mode t)

(setq c-default-style "bsd")
(setq c-basic-offset 2)
(setq-default tab-width 2)
(setq backwards-delete-char-untabify-method 'hungry)

(setq column-number-mode t)
(setq-default fill-column 79)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'electric-pair-local-mode)
(add-hook 'text-mode-hook 'auto-fill-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.emacs.d/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.emacs.d/backups/")))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(org-agenda-files '("~/Documents/todo.org"))
 '(package-selected-packages
   '(dired-quick-sort disable-mouse company yasnippet flycheck helm-evil-markers magit counsel-projectile projectile ace-window lsp-pyright python-mode which-key use-package undo-tree swiper-helm rainbow-mode pydoc pandoc org-pdftools openwith nyan-mode multi-term lsp-ui lsp-ivy latex-preview-pane ivy-rich hydra helpful general evil-surround evil-commentary evil-collection doom-themes doom-modeline counsel command-log-mode 2048-game)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(make-directory "~/.emacs.d/autosaves/" t)

;; --- Packages ---
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package undo-tree
  :config
  (global-undo-tree-mode))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-undo-system 'undo-tree)
  (setq evil-shift-width tab-width)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (evil-mode 1)
  :config
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  :bind
  ([remap evil-search-forward] . swiper))

(use-package evil-surround
  :requires evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :requires evil
  :config (evil-commentary-mode))

(use-package evil-collection
  :after evil
  :config
 (evil-collection-init))

(use-package which-key
  :init
  (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package openwith
  :config
  (openwith-mode t))

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . 'counsel-M-x)
         ("C-x b" . 'counsel-ibuffer)
         ("C-x C-f" . 'counsel-find-file)
         ("C-c f" . 'counsel-find-file)
         ("C-c b" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with "^"

(use-package ivy-rich
  :requires counsel
  :init
  (ivy-rich-mode t))

(use-package org
  :bind (("C-c a" . 'org-agenda)
         ("C-c l" . 'org-store.link)
         ("C-c c" . 'org-capture))
  :hook (org-mode . evil-org-mode)
  :config
  (setq org-src-fontify-natively t))

(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)
                             (C . t)))

(use-package evil-org
  :after org)

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-describe-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package all-the-icons
  :if (display-graphic-p))

;; if doom-modeline has some missing icons then run
;; M-x all-the-icons-install-fonts

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))
(use-package doom-themes)

(use-package hydra)

(load-theme 'doom-one t)
(defvar thingy/dark-theme 'doom-one)
(defvar thingy/light-theme 'doom-one-light)
(defvar thingy/current-theme thingy/dark-theme)

(set-face-attribute 'default nil :font "JuliaMono" :height 80)
(defvar thingy/mono-font "JuliaMono")
(defvar thingy/norm-font "Waree")
(defvar thingy/current-font thingy/mono-font)

(defun thingy/change-font (font)
  (set-face-attribute 'default nil :font font :height 80)
  (setq thingy/current-font font))

(defun thingy/toggle-mono-norm-mode ()
  "toggles mono/norm mode"
  (interactive)
  (cond ((eq thingy/current-font thingy/mono-font)
         (thingy/change-font thingy/norm-font))
        ((eq thingy/current-font thingy/norm-font)
         (thingy/change-font thingy/mono-font))))

(defun thingy/change-theme (theme)
  (progn (disable-theme thingy/current-theme))
  (progn (load-theme theme t))
  (setq thingy/current-theme theme))

(defun thingy/toggle-light-dark-mode ()
  "toggles light/dark mode"
  (interactive)
  (cond ((eq thingy/current-theme thingy/dark-theme)
         (thingy/change-theme thingy/light-theme))
        ((eq thingy/current-theme thingy/light-theme)
         (thingy/change-theme thingy/dark-theme))))

(use-package general
  :config
  (general-create-definer thingy/leader-keys
    :keymaps '(normal insert visual replace emacs)
    :prefix "C-c"
    :global-prefix "C-SPC")

  (thingy/leader-keys
   "h" '(windmove-left :which-key "move left")
   "j" '(windmove-down :which-key "move down")
   "k" '(windmove-up :which-key "move up")
   "l" '(windmove-right :which-key "move right")

   "a" '(:ignore a :which-key "asethetics stuff")
   "at" '(thingy/toggle-light-dark-mode :which-key "dark/light mode")
   "af" '(thingy/toggle-mono-norm-mode :which-key "mono/norm mode")
   
   "M-n" '(tab-bar-new-tab :which-key "new tab")
   "M-d" '(tab-bar-close-tab :which-key "close tab")
   "M-h" '(tab-bar-switch-to-prev-tab :which-key "prev tab")
   "M-l" '(tab-bar-switch-to-next-tab :which-key "next tab")
   "M-," '(tab-bar-rename-tab :which-key "rename tab")
   "M-t" '(tab-bar-switch-to-tab :which-key "switch tab")

   "?" '(split-window-right :which-key "split right")
   "_" '(split-window-below :which-key "split below")
   "r" '(rename-buffer :which-key "rename buffer")
   "d" '(delete-window :which-key "delete window")

   "u" '(counsel-unicode-char :which-key "Insert unicode char")
   "m" '(bookmark-jump :which-key "bookmark mump")))

(general-define-key
 :keymaps 'org-mode-map
 "C-c C-s" 'org-toggle-narrow-to-subtree)

(use-package rainbow-mode
  :config
  (setq rainbow-mode t))
 
;; Code stolen from https://github.com/ramnes/move-border/
(defun xor (b1 b2)
  (or (and b1 b2)
      (and (not b1) (not b2))))

(defun move-border-left-or-right (arg dir)
  "General function covering move-border-left and move-border-right. If DIR is
     t, then move left, otherwise move right."
  (interactive)
  (if (null arg) (setq arg 3))
  (let ((left-edge (nth 0 (window-edges))))
    (if (xor (= left-edge 0) dir)
        (shrink-window arg t)
      (enlarge-window arg t))))

(defun move-border-up-or-down (arg dir)
  "General function covering move-border-up and move-border-down. If DIR is
     t, then move up, otherwise move down."
  (interactive)
  (if (null arg) (setq arg 3))
  (let ((top-edge (nth 1 (window-edges))))
    (if (xor (= top-edge 0) dir)
        (shrink-window arg nil)
      (enlarge-window arg nil))))

(defun move-border-left (arg)
  (interactive "P")
  (move-border-left-or-right arg t))

(defun move-border-right (arg)
  (interactive "P")
  (move-border-left-or-right arg nil))

(defun move-border-up (arg)
  (interactive "P")
  (move-border-up-or-down arg t))

(defun move-border-down (arg)
  (interactive "P")
  (move-border-up-or-down arg nil))
;; End of code stolen


(use-package ace-window)

(defhydra hydra-window-manage (:foreign-keys warn
                               :hint nil)
  "
Movement: hjkl Border movement: C-  Tab stuff: M-  rename tab: M-
bookmarks: m  find file: f  switch buffer: b  text: =-
split: _?  rename buffer: r  delete window: d  quit: q
"
  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)

  ("C-h" move-border-left)
  ("C-j" move-border-down)
  ("C-k" move-border-up)
  ("C-l" move-border-right)

  ("_" split-window-below)
  ("?" split-window-right)
  ("r" rename-buffer)
  ("d" delete-window)

  ("C-M-l" (tab-bar-move-tab 1))
  ("C-M-h" (tab-bar-move-tab -1))
  ("M-l" tab-bar-switch-to-next-tab)
  ("M-h" tab-bar-switch-to-prev-tab)
  ("M-n" tab-bar-new-tab)
  ("M-d" tab-bar-close-tab)
  ("M-," tab-bar-rename-tab)
  ;; insert commands to move tabs around

  ("=" text-scale-increase)
  ("-" text-scale-decrease)

  ("b" counsel-switch-buffer)
  ("f" counsel-find-file)
  ("m" bookmark-jump)

  ("q" nil :color blue))

(thingy/leader-keys
  "w" '(hydra-window-manage/body :which-key "buffer stuff"))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c C-l")
  :config
  (setq lsp-enable-which-key-integration t)
  (setq lsp-ui-doc-enable nil)
  (setq lsp-enable-relative-indentation t)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-ui-sideline-enable nil))

(use-package lsp-ivy)

(use-package company
  :hook (after-init-hook . global-company-mode))


(use-package python-mode
  :mode "\\.py\\'"
  :hook (python-mode . lsp-deferred)
  :config
  (setq python-indent-level 4))

(use-package lsp-pyright
  :hook (python-mode . (lambda()
                             (require 'lsp-pyright)
                             (lsp))))

(use-package pydoc)

(add-hook 'c-mode-hook 'lsp-deferred) 
(add-hook 'c++-mode-hook 'lsp-deferred) 
(add-hook 'prog-mode-hook 'rainbow-mode)
(setq lsp-diagnostics-provider :none)

(use-package multi-term
  :bind ("C-c t" . multi-term))

(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (yas-global-mode t))

(add-hook 'text-mode-hook 'display-fill-column-indicator-mode t)

;; (use-package nyan-mode
;;   :init
;;   (nyan-mode)
;;   (nyan-start-animation))

(use-package disable-mouse
  :config
  (global-disable-mouse-mode))

(mapc #'disable-mouse-in-keymap
      (list evil-motion-state-map
            evil-normal-state-map
            evil-visual-state-map
            evil-insert-state-map
            evil-replace-state-map))

(use-package dired-quick-sort
  :bind (("C-s" . 'hydra-dired-quick-sort/body)))


;; --- Key Bindings ---
(global-set-key (kbd "<f2>") 'save-buffer)
(global-set-key (kbd "<f3>") 'kill-buffer)
(global-set-key (kbd "<f9>") 'display-line-numbers-mode)
(global-set-key (kbd "<f10>") 'display-fill-column-indicator-mode)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(define-key emacs-lisp-mode-map (kbd "C-c e") 'eval-last-sexp)

;; --- Mode Line config ---

;; (make-face 'mode-line-folder-face)
;; (make-face 'mode-line-position-face)
;; (make-face 'mode-line-position-percent-face)
;; (make-face 'mode-line-evil-normal-face)
;; (make-face 'mode-line-evil-insert-face)
;; (make-face 'mode-line-evil-replace-face)
;; (make-face 'mode-line-evil-visual-face)
;; (make-face 'mode-line-evil-emacs-face)

;; (set-face-attribute 'mode-line nil
;; 		    :foreground "GreenYellow" :background "DarkGreen"
;; 		    :inverse-video nil
;; 		    :box '(:line-width 1 :color "Orange4" :style nil))

;; (set-face-attribute 'mode-line-inactive nil
;; 		    :inherit 'mode-line
;; 		    :inverse-video t)

;; (set-face-attribute 'mode-line-folder-face nil
;; 	       :inherit 'mode-line-face)

;; (set-face-attribute 'mode-line-position-face nil
;; 		    :foreground "Orange1" :background "Orange4")

;; (set-face-attribute 'mode-line-position-percent-face nil
;;                     :foreground "DarkSlateGray1" :background "MediumPurple3")

;; (set-face-attribute 'mode-line-evil-normal-face nil
;;                     :foreground "White" :background "Grey")

;; (set-face-attribute 'mode-line-evil-insert-face nil
;;                     :foreground "White" :background "Green4")

;; (set-face-attribute 'mode-line-evil-replace-face nil
;;                     :foreground "White" :background "LightGoldenrod1")

;; (set-face-attribute 'mode-line-evil-visual-face nil
;;                     :foreground "White" :background "SlateBlue3")

;; (set-face-attribute 'mode-line-evil-emacs-face nil
;;                     :foreground "Black" :background "DarkOrange")

;; (defun simple-mode-line-render (left right)
;;   "Return a string of 'window-width' length containing LEFT, and RIGHT aligned respectively."
;;   (let* ((available-width (- (window-width) (length left) 2)))
;;     (format (format " %%s %%%ds " available-width) left right)))

;; --- evil mode stuff ---
;; (setq
;;  evil-normal-state-tag (propertize " N " 'face 'mode-line-evil-normal-face)
;;  evil-insert-state-tag (propertize " I " 'face 'mode-line-evil-insert-face)
;;  evil-replace-state-tag (propertize " R " 'face 'mode-line-evil-replace-face)
;;  evil-visual-state-tag (propertize " V " 'face 'mode-line-evil-visual-face)
;;  evil-emacs-state-tag (propertize " E " 'face 'mode-line-evil-emacs-face))

;; (setq-default mode-line-format
;;               '((:eval evil-mode-line-tag)
;;                 (:propertize " %p " face mode-line-position-percent-face)
;;                 (:propertize " %02l:%02C " face mode-line-position-face)
;;                 " | "
;;                 " | "
;;                 (:propertize " %b " face mode-line-folder-face)))

;; (defvar thingy/scratch-messages
;;   '(
;; ";; Hello! Welcome to McDonalds!"
;; ";; Hello! Welcome to McDonalds?"
;; ";; Welcome back, I hope you have a great time here"
;; ";; I hope you are doing ok..."
;; ";; I miss being human"
;; ";; Who wakes me from my slumber?"
;; ";; Why are you?"
;; ";; Who are you and what have you done with ... I forgot"
;; ";; Also try Vim!"
;; ";; Polly the parrot says \"Hi!\""
;; ";; Now with more beef!"
;; ";; Emacs"
;; ";; thing"
;; ";; Hello! Welcome to Thingymacs"
;; ";; Burn your eyes out with \"C-SPC a t\"!"
;; ";; I for one welcomes our new robot overlords"
;; ";; Is keyboard cat still a thing?"
;; ";; I contain the kitchen sink"
;; ";; DOOOOOOOOOOOOOOOOOOOM"
;; ";; Look at all those chickens"
;; ";; Objection!"
;; ";; Hold it!"
;; ";; Don't forget to breathe"
;; ";; Sometimes I think I'm the coolest. Most of the times I'm not"
;; ";; I'm just your average everyday notpad."
;; ";; Nothing suspicious going on here. Just Emacs"
;; ";; Have you joined the Church of Emacs yet?"
;; ";; Why did the chicken cross the road?"
;; ";; Why /did/ the chicken cross the road?"
;; ";; They say that carrots improve your eyesight but I stuck them in my eyes and
;; ;; now I'm blind"
;; ";; Don't forget to drink some water"
;; ";; Bean"
;; ";; (insert generic scratch message here)"
;; ";; "
;; ""
;; ";; !?"
;; ";; Do you remember the 21st night of September"
;; ";; I like bunnies"
;; ";; Have you heard about Emacs?"))

;; (setq initial-scratch-message
      ;; (nth (random (length thingy/scratch-messages)) thingy/scratch-messages))
(setq inital-scratch-message "")
