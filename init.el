;;;; Emacs configuration file

;;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; Async - package
(add-to-list 'load-path "~/.emacs.d/packages/macs-async")

;;; Helm - package
(add-to-list 'load-path "~/.emacs.d/packages/helm")
(require 'helm-config)

;;; Helm-projectile
(require 'helm-projectile)
(helm-projectile-on)

;;;-------


;; org
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(setq org-todo-keywords
  '((sequence "TODO" "IN-PROGRESS" "WAITING" "DONE")))


;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;;; Theme
(load-theme 'material t)


;;; spaceline
(require 'spaceline-config)
(spaceline-emacs-theme)

(global-anzu-mode +1)
(setq anzu-cons-mode-line-p nil)
(spaceline-toggle-anzu-on)

(setq ns-use-srgb-colorspace nil)
(spaceline-toggle-buffer-size-off)
;;; (spaceline-helm-mode)

(spaceline-toggle-minor-modes-off)
(spaceline-toggle-hud-off)

(setq powerline-default-separator 'arrow)
(setq powerline-height 18)
(spaceline-compile)


;; flycheck
(global-flycheck-mode)

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better

(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)


;; adjust indents for web-mode to 4 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-enable-auto-closing t)
  (setq web-mode-enable-auto-pairing t)
  (setq web-mode-enable-css-colorization t)
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 4)
  (setq web-mode-code-indent-offset 4))
(add-hook 'web-mode-hook  'my-web-mode-hook)

;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

;;; mode for jsx
;;(add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode))
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Uses spaces instead of tabs
(setq-default indent-tabs-mode nil)


;;; Cache projectile
(setq projectile-enable-caching t)


;; auto-complete
(ac-config-default)

;;; tern
(add-hook 'js2-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

(defun delete-tern-process ()
  (interactive)
  (delete-process "Tern"))



;; js2-bounce tabs
(setq js2-bounce-indent-p t)

;; newline-without-break-of-line
(defun newline-without-break-of-line ()
  "1. move to end of the line.
  2. insert newline with index"

  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))


(global-set-key (kbd "<C-return>") 'newline-without-break-of-line)


;;; disable show matching parenthesis


(customize-set-variable 'blink-cursor-mode nil)
(set-face-attribute 'default nil :family "Source Code Pro")
(set-face-attribute 'default nil :height 134)




;;; ----------------



;;; Expand-region key bind
(global-set-key (kbd "C-@") 'er/expand-region)


;;; show matching parenthesis
(show-paren-mode 0)

;;; mark line number
(hlinum-activate)

;;; Key remaps
(setq mac-option-key-is-meta nil)
(setq mac-command-key-is-meta t)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;;; Display new line
(global-linum-mode t)

;;; Inhibit welcome screen
(setq inhibit-startup-screen t)

(setq c-basic-offset 4)     ; indents 4 chars
(setq tab-width 4)          ; and 4 char wide for TAB
(setq indent-tabs-mode nil) ; And force use of space

(with-eval-after-load 'helm
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "<backtab>") 'helm-select-action))

(global-set-key (kbd "M-x") #'helm-M-x)
(global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
(global-set-key (kbd "C-x C-f") #'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(define-key isearch-mode-map (kbd "M-s o") 'helm-occur-from-isearch)

(global-set-key (kbd "M-m") 'iy-go-to-char)
(global-set-key (kbd "M-i") 'back-to-indentation)


;;; cursor follows ocurrens of helm-multi-occur
(defmethod helm-setup-user-source ((source helm-source-multi-occur))
  (setf (slot-value source 'follow) 1))

;;; Deletes region of selected text with any key
(pending-delete-mode t)

;;; Emacs access to .bashrc
(setq shell-file-name "bash")
(setq shell-command-switch "-ic")

;;; Delete white space on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Start server
(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(compilation-message-face (quote default))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "4cbec5d41c8ca9742e7c31cc13d8d4d5a18bd3a0961c18eb56d69972bbcf3071" "6952b5d43bbd4f1c6727ff61bc9bf5677d385e101433b78ada9c3f0e3787af06" "b9cbfb43711effa2e0a7fbc99d5e7522d8d8c1c151a3194a4b176ec17c9a8215" "9b402e9e8f62024b2e7f516465b63a4927028a7055392290600b776e4a5b9905" "f5512c02e0a6887e987a816918b7a684d558716262ac7ee2dd0437ab913eaec6" "f78de13274781fbb6b01afd43327a4535438ebaeec91d93ebdbba1e3fba34d3c" "87233846530d0b2c50774c74c4aca06a1472504c63ccd4ab2b1021b3e56a69e9" default)))
 '(fci-rule-color "#383838")
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-tail-colors
   (quote
    (("#3C3D37" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#3C3D37" . 100))))
 '(magit-diff-use-overlays nil)
 '(menu-bar-mode nil)
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(nyan-wavy-trail t)
 '(org-agenda-files (quote ("~/Desktop/test-org.org")))
 '(package-selected-packages
   (quote
    (eslint-fix iy-go-to-char rjsx-mode helm-swoop anzu material-theme hlinum moe-theme badger-theme monokai-alt-theme monokai-theme zenburn-theme tern-auto-complete tern auto-complete expand-region exec-path-from-shell web-mode json-mode js2-mode flycheck helm-projectile projectile org helm-ag)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#A6E22E")
 '(pos-tip-foreground-color "#272822")
 '(projectile-mode t nil (projectile))
 '(tool-bar-mode nil)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(weechat-color-list
   (unspecified "#272822" "#3C3D37" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
