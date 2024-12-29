;; パッケージ管理
; straight.el
(setq straight-use-package-by-default t)
(setq package-enable-at-startup nil) ; package.elを無効化
(let ((bootstrap-file (concat user-emacs-directory "straight/repos/straight.el/bootstrap.el"))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

; use-package
(straight-use-package 'use-package)

;; 日本語環境とUTF-8の設定
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
; ターミナルを使用する場合のみ設定
(when (not (display-graphic-p))
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8))

;; UI改善
; Theme
(use-package gruvbox-theme :config (load-theme 'gruvbox-dark-hard t))
(set-face-foreground 'font-lock-comment-face "purple")
; Other Settings
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t)
(global-display-line-numbers-mode) ; 行番号表示
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil) ; スペースでインデント
; all-the-icons
; フォントが必要なので、初回セットアップ時に M-x all-the-icons-install-fonts を実行
(defvar my/all-the-icons-font-dir "~/.local/share/fonts/"
  "Directory where all-the-icons fonts will be installed.")

(defvar my/all-the-icons-installed-p nil
  "Flag indicating whether all-the-icons fonts have been installed.")

; dired-sidebar
(use-package dired-sidebar
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :bind (("C-c t" . dired-sidebar-toggle-sidebar))
  :config
  (setq dired-sidebar-use-term-integration t) ; ターミナル統合
  (setq dired-sidebar-use-custom-font t)     ; カスタムフォント
  (setq dired-sidebar-show-hidden-files t)   ; 隠しファイルを表示
  (setq dired-sidebar-width 20)
  ;; Emacs 29ではウィンドウ管理に関する機能が改善されているため、以下の設定を検討
  (when (featurep 'pixel-scroll)
    (pixel-scroll-precision-mode 1))) ; スムーズスクロールを有効化

(use-package nerd-icons)
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; バックアップ設定
(setq make-backup-files nil)       ; バックアップファイルを無効化
(setq auto-save-default nil)       ; 自動保存を無効化

;; 操作性
; Backspace even in mini buffer
(define-key key-translation-map (kbd "C-h") (kbd "<DEL>"))
; Resize Window
(defun window-resizer ()
  "Resize the selected window interactively."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx
         (if (= (nth 0 (window-edges)) 0)
             1
           -1))
        (dy
         (if (= (nth 1 (window-edges)) 0)
             1
           -1))
        c)
    (catch 'end-flag
      (while t
        (let ((msg (format "Use [l/h/j/k] to resize, [q] to quit: %dx%d"
                           (window-width) (window-height))))
          (minibuffer-message msg))
        (setq c (read-char))
        (cond
         ((= c ?l)
          (enlarge-window-horizontally dx))
         ((= c ?h)
          (shrink-window-horizontally dx))
         ((= c ?j)
          (enlarge-window dy))
         ((= c ?k)
          (shrink-window dy))
         ((= c ?q)
          (minibuffer-message "Resize quit")
          (throw 'end-flag t)))))))
(global-set-key (kbd "C-c w") 'window-resizer)

; ace-window
(use-package ace-window
  :bind ("C-x o" . ace-window))

; Toggle behavior of word wrap
(setq-default truncate-lines nil)

(defun toggle-truncate-lines ()
  "Toggle truncat lines"
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))

(global-set-key (kbd "C-c l") 'toggle-truncate-lines) ; ON/OFF



