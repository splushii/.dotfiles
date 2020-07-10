(setq-local indent 2)
(setq column-number-mode t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width indent)
(setq js-indent-level indent)
(setq python-indent-offset 4)
(setq c-basic-offset indent)
(setq cperl-indent-level indent)
(setq css-indent-offset indent)
(setq vcl-indent-level indent)

(add-hook 'groovy-mode-hook(lambda()
                             (c-set-offset 'label 2)))

(add-to-list 'auto-mode-alist '("\\.js\\'" . rjsx-mode))
;; Handlebars.js
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.vcl\\'" . vcl-mode))

;; ido mode
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

;; disable menu-bar
(setq menu-bar-mode nil)

;; Always newline on save
(setq require-final-newline t)

;; Deletion mode
(delete-selection-mode 1)

;; Clipboard stuff
;; (setq x-select-enable-clipboard t)
;; (setq x-select-enable-primary t)
;; (setq select-enable-clipboard t)
;; (setq select-enable-primary t)

;; 80 col marker
(setq-default
 whitespace-line-column 80
 whitespace-style '(face lines-tail))
(add-hook 'prog-mode-hook #'whitespace-mode)

;; Transpose lines
(defun move-line-up ()
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

;; Backup files settings
(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
    version-control t)       ; use versioned backups

;; Key bindings
(global-set-key (kbd "M-p") 'move-line-up)
(global-set-key (kbd "M-n") 'move-line-down)
(global-set-key (kbd "C-c C-b") 'magit-blame)
(global-set-key (kbd "C-c C-m") 'magit-status)
(global-set-key (kbd "C-c C-r") 'rgrep)
(global-set-key (kbd "C-c .") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c ,") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-_") 'mc/mark-all-like-this)
;; Override buffer-menu-other-window with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; wl-clipboard
(setq wl-copy-process nil)
(defun wl-copy (text)
  (setq wl-copy-process (make-process :name "wl-copy"
                                      :buffer nil
                                      :command '("wl-copy" "-f" "-n")
                                      :connection-type 'pipe))
  (process-send-string wl-copy-process text)
  (process-send-eof wl-copy-process))
(defun wl-paste ()
  (if (and wl-copy-process (process-live-p wl-copy-process))
      nil ; should return nil if we're the current paste owner
      (shell-command-to-string "wl-paste -n | tr -d \r")))
(setq interprogram-cut-function 'wl-copy)
(setq interprogram-paste-function 'wl-paste)

;; Melpa
(require 'package)
(add-to-list 'package-archives
	     '("melpa" .
	       "https://melpa.org/packages/"))
(package-initialize)

;; Show trailing whitespace
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wombat)))
 '(delete-selection-mode nil)
 '(package-selected-packages
   (quote
    (terraform-mode go-mode docker-tramp lxd-tramp kotlin-mode vcl-mode pkgbuild-mode fill-column-indicator multiple-cursors toml-mode yaml-mode web-mode rjsx-mode markdown-mode magit jinja2-mode groovy-mode dockerfile-mode)))
 '(show-trailing-whitespace t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(region ((t (:background "brightblack")))))
