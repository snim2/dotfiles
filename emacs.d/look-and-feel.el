;; Sarah's emacs configurator.

;; Look and feel changes.

;; Author: Sarah Mount <(concat "snim2" at-symbol "snim2.org")>

;; Copyright (C) Sarah Mount, 2010.

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(message "Loading look-and-feel configuration.")

;; Faster response to typing.
(setq echo-keystrokes 0.1)

;; Cut and paste between Emacs and other programs.
;; (x-select-enable-clipboard was renamed in Emacs 25.)
(setq select-enable-clipboard t)

;; Completion.
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; Indicate the fill column using the built-in indicator (Emacs 27+).
;; fill-column-indicator package is no longer needed.
(setq-default fill-column 80)
(global-display-fill-column-indicator-mode 1)
(set-face-attribute 'fill-column-indicator nil :foreground "#555555" :background 'unspecified)

;; Line numbers in all buffers.
(global-display-line-numbers-mode 1)

;; Indentation.
(setq tab-width 4)
(setq indicate-empty-lines t)
(setq-default indent-tabs-mode nil)

;; Visible whitespace: show tabs and trailing spaces, not every space.
(setq whitespace-style '(face tabs tab-mark trailing empty))
(global-whitespace-mode 1)

;; Use highlighting for search and replace.
(setq search-highlight t
      query-replace-highlight t)

;; Use y/n rather than yes/no (Emacs 28+ uses use-short-answers).
(setq use-short-answers t)

;; Modeline settings.
(setq display-time-24hr-format t)
(display-time)
(line-number-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

;; Don't let the mouse obscure the cursor.
(mouse-avoidance-mode 'animate)

;; Fix scrolling.
(setq scroll-preserve-screen-position t)

;; Mouse/trackpad scroll in terminal mode.
(xterm-mouse-mode 1)
(global-set-key (kbd "<mouse-4>")   (lambda () (interactive) (scroll-down 3)))
(global-set-key (kbd "<mouse-5>")   (lambda () (interactive) (scroll-up 3)))
(global-set-key (kbd "<wheel-up>")   (lambda () (interactive) (scroll-down 3)))
(global-set-key (kbd "<wheel-down>") (lambda () (interactive) (scroll-up 3)))

;; Smooth scrolling in GUI mode (Emacs 29+).
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

;; Turn that sodding bell off.
(setq ring-bell-function 'ignore)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; What happens on startup.                                              ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Turn off splash screen.
(setq inhibit-splash-screen t)

;; Set up the main window.
(column-number-mode 1)
(display-time-mode 1)
(show-paren-mode 1)
(size-indication-mode 1)

;; Start maximised.
(toggle-frame-maximized)

;; Message in scratch buffer.
(setq initial-scratch-message (concat "#\n"
                                      "# This is a scratch buffer.\n"
                                      "# Use M-x gist-buffer to save contents on Github.\n"
                                      "#\n"
                                      "\n"
                                      "__author__ = ''\n"
                                      "__date__ = ''\n\n"))

;; What mode the scratch buffer should start in.
(setq initial-major-mode 'python-mode)

;; Ensure that if we kill the scratch buffer we can recreate it.
(defun create-scratch-buffer nil
  "Create a new scratch buffer."
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (insert-file-contents "~/.emacs.d/scratch.txt")
  (python-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Configuration for fonts and syntax highlighting.                      ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Use Source Code Pro if available.
(when (and window-system (find-font (font-spec :name "Source Code Pro")))
  (set-frame-font "Source Code Pro-12"))

(setq font-lock-maximum-decoration t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)
(global-hl-line-mode 1)
(set-face-background 'hl-line "#333")

;; Highlight trailing whitespace and tabs.
(use-package highlight-chars
  :ensure t
  :config
  (hc-toggle-highlight-trailing-whitespace t)
  (hc-toggle-highlight-tabs t))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Display Greek letter names as Unicode characters in programming modes.
(defun pretty-greek ()
  (let ((greek '(("alpha" . "α") ("beta" . "β") ("gamma" . "γ")
                 ("delta" . "δ") ("epsilon" . "ε") ("zeta" . "ζ")
                 ("eta" . "η") ("theta" . "θ") ("iota" . "ι")
                 ("kappa" . "κ") ("lambda" . "λ") ("mu" . "μ")
                 ("nu" . "ν") ("xi" . "ξ") ("omicron" . "ο")
                 ("pi" . "π") ("rho" . "ρ") ("sigma_final" . "ς")
                 ("sigma" . "σ") ("tau" . "τ") ("upsilon" . "υ")
                 ("phi" . "φ") ("chi" . "χ") ("psi" . "ψ")
                 ("omega" . "ω"))))
    (cl-loop for (word . char) in greek
             do (font-lock-add-keywords nil
                  `((,(concat "\\(?:^\\|[^a-zA-Z0-9]\\)\\(" word "\\)[^a-zA-Z]")
                     (0 (progn (compose-region (match-beginning 1) (match-end 1)
                                               ,char)
                               nil))))))))
