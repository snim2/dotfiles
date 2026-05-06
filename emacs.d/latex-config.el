;; Sarah's emacs configurator.

;; Configuration for LaTeX editing.

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

(message "Loading LaTeX configuration.")

;; pandoc-mode: convert between markup formats.
(use-package pandoc-mode
  :ensure t)

;;; Which program reads DVI files?
(setq tex-dvi-view-command "/usr/bin/xdvi")

;; Add new block names for maths / code typesetting.
(setq latex-block-names '("theorem" "corollary" "proof" "lstlisting"))

;; Insert new slide (for LaTeX Beamer).
(defun insert-beamer-slide ()
  "Insert a new LaTeX Beamer slide."
  (interactive)
  (insert "\\frame\n"
          "{\n"
          "  \\frametitle{}\n"
          "  \\framesubtitle{}\n"
          "\n"
          "  \\begin{definition}\n"
          "\n"
          "  \\end{definition}\n"
          "\n"
          "  \\begin{itemize}[<+-| alert@+>]\n"
          "  \\item\n"
          "  \\end{itemize}\n"
          "\n"
          "}\n\n"))

;; Re-bind the compile command to use "make" rather than pdflatex etc.
(defun my-latex-mode-common-hook ()
  (defun latex-compile ()
    (interactive)
    (set (make-local-variable 'compile-command)
         (let ((file (file-name-nondirectory buffer-file-name))) "make"))
    (compile compile-command))
  (local-unset-key "\C-c\C-c")
  (local-set-key "\C-c\C-c" 'latex-compile))

(add-hook 'latex-mode-hook 'my-latex-mode-common-hook)

;; Find all WRITEME, TODO etc.
(add-hook 'latex-mode-hook
          (lambda ()
            (highlight-lines-matching-regexp "\\<\\(FIXME\\|WRITEME\\|WRITEME!\\|TODO\\|BUG\\):?"
                                             'hi-green-b)))

(add-hook 'latex-mode-hook 'flyspell-mode)
(add-hook 'latex-mode-hook 'turn-on-reftex)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; Set faces for writegood-mode.
(custom-set-faces
 '(writegood-weasels-face ((((class color)) :foreground "Grey" :background "Green")))
 '(writegood-passive-voice-face ((((class color)) :foreground "#666666" :background "#dddd00")))
 '(writegood-duplicates-face ((((class color)) :foreground "White" :background "Red"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; org-mode configuration.                                               ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; org-install was merged into org in Emacs 25; just require org directly.
(require 'org)

(setq org-plantuml-jar-path "~/bin/plantuml.jar")

(add-hook 'org-babel-after-execute-hook 'org-display-inline-images 'append)

;; Use listings for source code in LaTeX export.
(setq org-latex-listings t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (dot . t)
   (R . t)
   (python . t)
   (ruby . t)
   (gnuplot . t)
   (clojure . t)
   (shell . t)
   (org . t)
   (plantuml . t)
   (latex . t)))

;; Do not prompt to confirm evaluation.
;; This may be dangerous - make sure you understand the consequences
;; of setting this -- see the docstring for details.
(setq org-confirm-babel-evaluate nil)

;; Use fundamental mode when editing plantuml blocks with C-c '.
(add-to-list 'org-src-lang-modes '("plantuml" . fundamental))
