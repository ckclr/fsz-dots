(add-to-list 'load-path (expand-file-name "elisp.fsz" user-emacs-directory))
(add-to-list 'native-comp-eln-load-path "~/eln-cache")
;; (add-to-list 'load-path "~/.emacs.d/site-lisp/")

(setq package-user-dir "~/elpa.fsz")

(setq custom-file (locate-user-emacs-file "custom.el"))
;; 禁用启动界面
(setq inhibit-startup-message t)

;; 启动时宽高
(when window-system (set-frame-size (selected-frame) 170 35))

;; 执行后可以用shift+方向键来切换window
;; (windmove-default-keybindings)

;; 记住window配置状态，C-c left or right来切换
(winner-mode 1)

;; 显示光标列数
(setq column-number-mode t)

;; 高亮当前行
;; (global-hl-line-mode t)

;; 设置 tab 宽度
(setq-default tab-width 10)

;; frame 标题显示 buffer 名
(setq frame-title-format "%b")

;; 让 dired mode 中目录排在前面
(require 'ls-lisp)
(setq ls-lisp-dirs-first t)
(setq ls-lisp-use-insert-directory-program nil)

;; 最近打开的文件
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 100)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; 关闭文件备份
(setq make-backup-files nil)

;; 自动居中
(defun fsz/frame-recenter (&optional frame)
  "Center FRAME on the screen.
FRAME can be a frame name, a terminal name, or a frame.
If FRAME is omitted or nil, use currently selected frame."
  (interactive)
  (unless (eq 'maximised (frame-parameter nil 'fullscreen))
    (let* ((frame (or (and (boundp 'frame)
                           frame)
                      (selected-frame)))
           (frame-w (frame-pixel-width frame))
           (frame-h (frame-pixel-height frame))
           ;; frame-monitor-workarea returns (x y width height) for the monitor
           (monitor-w (nth 2 (frame-monitor-workarea frame)))
           (monitor-h (nth 3 (frame-monitor-workarea frame)))
           (center (list (/ (- monitor-w frame-w) 2)
                         (/ (- monitor-h frame-h) 2))))
      (apply 'set-frame-position (flatten-list (list frame center))))))

;;让鼠标滚动更好用
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; gui 下才有的设置
(menu-bar-mode 0)
(if (display-graphic-p)
    (progn
      (toggle-scroll-bar 0)
      (tool-bar-mode 0)
      (add-hook 'after-init-hook #'fsz/frame-recenter)
      (add-hook 'after-make-frame-functions #'fsz/frame-recenter)
      (set-frame-font "Sarasa Term Slab SC 11" nil t)
      (load-theme 'modus-operandi t)))

;; open init.el
;; global-set-key expects an interactive command. ref: https://stackoverflow.com/q/1250846
(global-set-key (kbd "M-g i") (lambda () (interactive) (find-file user-init-file)))

;; eval init file
(global-set-key (kbd "M-g e") (lambda () (interactive) (eval-expression (load-file user-init-file))))

;; 打开控制台
(defun fsz/term-other-window(choice)
  "接收 CHOICE 打开 term window."
  (interactive "copen terminal right or below ? (r/b): ")
  (if (char-equal choice ?r)
      (split-window-right)
    (split-window-below))
  (other-window 1)
  (if (string-equal system-type "windows-nt") ;; windows 下不能用 vterm
      (eshell)
    (vterm)))
(global-set-key (kbd "M-g t") 'fsz/term-other-window)

;; 开启 narrow 功能
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;; 注释快捷键更改
(global-set-key (kbd "M-;") 'comment-line)

;; 全局开启行号
(global-display-line-numbers-mode)

;; 平滑滚动
(setq scroll-conservatively 1000)

;; 当文件被外部修改时自动载入、更新 buffer
(global-auto-revert-mode t)

;; .h 和 .cpp 之间切换，也许应该限定在 c/c++ mode 下
(global-set-key (kbd "M-o") 'ff-find-other-file)

;; 默认编码为 utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))


(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
		     ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(package-initialize)

;;防止反复调用 package-refresh-contents 会影响加载速度
(unless package-archive-contents (package-refresh-contents))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; 只能对 init 之后的操作做 benchmark，所示要尽量往前放
(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; (use-package tabbar
;;   :ensure t
;;   :config (tabbar-mode 1))

(use-package company
  :ensure t
  :init
  (global-company-mode t)
  :config
  (setq company-minimum-prefix-length 2)
  (setq company-idle-delay 0.2)
  :bind (:map company-active-map
	    ("C-n" . 'company-select-next)
	    ("C-p" . 'company-select-previous)))

(use-package restart-emacs
  :ensure t)

(use-package expand-region
  :ensure t
  :config
  (global-set-key (kbd "C-=") 'er/expand-region))

(use-package eglot
  :ensure t
  :config
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'python-mode-hook 'eglot-ensure)
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio"))))

(use-package blacken
  :ensure t
  :config
  (setq blacken-line-length 1024)
  :bind
  ("M-F" . 'blacken-buffer))

;; ----------------------------------------------------------------------------------------

;; minibuffer 的补全框架，类似 ivy
(use-package vertico
  :ensure t
  :init
  (vertico-mode t))

;; minibuffer 的模糊搜索
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless)))

;; minibuffer 搜索候选加 annotation
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode t))

;; (use-package evil
;;   :ensure t
;;   :init
;;   (evil-mode t))

;; (use-package org-download
;;   :ensure t)

;; (use-package centaur-tabs
;;   :ensure t
;;   :demand
;;   :config
;;   (centaur-tabs-mode t)
;;   :bind
;;   ("C-<prior>" . centaur-tabs-backward)
;;   ("C-<next>" . centaur-tabs-forward))

;; (use-package keycast
;;   :ensure t
;;   :config
;;   (keycast-log-mode t))

;; load theme
;; (use-package zenburn-theme :ensure t)
;; (load-theme 'modus-vivendi t)
;; (load-theme 'modus-operandi t)
;; (load-theme 'zenburn t)

;; (setq org-startup-with-inline-images t)


;; (use-package org-noter
;;   :ensure t)

;; (use-package pdf-tools
;;   :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-mode t)
  :bind
  ("C-c p" . projectile-command-map))

;; (use-package beacon
;;   :ensure t
;;   :config
;;   (beacon-mode t))

;; (use-package ag
;;   :defer t
;;   :ensure t)

(use-package rg
  :defer t
  :ensure t)

(setq org-image-actual-width (list 800))
(setq org-startup-with-inline-images t)
(add-hook 'org-mode-hook #'turn-on-font-lock)

(use-package org-fragtog
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-fragtog-mode)
  ;; (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))
  (setq org-src-fontify-natively t))

(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))))


(custom-theme-set-faces
 'user
 '(variable-pitch ((t (:family "Sarasa Term Slab SC" :height 120 :weight thin))))
 '(fixed-pitch ((t ( :family "Sarasa Term Slab SC" :height 120)))))

;; (custom-theme-set-faces
;;  'user
;;  '(org-block ((t (:inherit fixed-pitch))))
;;  '(org-code ((t (:inherit (shadow fixed-pitch)))))
;;  '(org-document-info ((t (:foreground "dark orange"))))
;;  '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
;;  '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
;;  '(org-link ((t (:foreground "royal blue" :underline t))))
;;  '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;  '(org-property-value ((t (:inherit fixed-pitch))) t)
;;  '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
;;  '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
;;  '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
;;  '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))


;; (use-package good-scroll
;;   :ensure t
;;   :config
;;   (good-scroll-mode t))

;;  (use-package ox-hugo
;;   :ensure t
;;   :pin melpa
;;   :after ox)

;; (use-package grip-mode
;;   :ensure t
;;   :bind (:map markdown-mode-command-map
;;          ("g" . grip-mode)))

;; ----------------------------------------------------------------------------------------
;; c/cc
;; ----------------------------------------------------------------------------------------
(setq c-default-style "linux"
      c-basic-offset 4)

;; (use-package vterm
;;     :ensure t)

;; (use-package leetcode
;;   :ensure t)

;; 为 emacsclient 设置无效设置的
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (select-frame frame)
	  (toggle-scroll-bar 0)
	  (tool-bar-mode 0)
	  (add-hook 'after-init-hook #'fsz/frame-recenter)
	  (add-hook 'after-make-frame-functions #'fsz/frame-recenter)
	  (set-frame-font "Sarasa Term Slab SC 11" nil t)
	  (load-theme 'modus-operandi t)
            (raise-frame frame)))

(when (eq system-type 'windows-nt)
  (setq locale-coding-system 'gb18030)  ;此句保证中文字体设置有效
  (setq w32-unicode-filenames 'nil)       ; 确保file-name-coding-system变量的设置不会无效
  (setq file-name-coding-system 'gb18030) ; 设置文件名的编码为gb18030
  )
