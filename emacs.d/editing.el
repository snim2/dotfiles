;; Sarah's emacs configurator.

;; Configuration for general text editing.

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

(message "Loading text editing configuration.")

;; Tramp should use ssh.
(setq tramp-default-method "ssh")

;; Searches and matches should ignore case.
(setq-default case-fold-search t)

;;; org-mode additions.
(defun snim2-org ()
  (display-line-numbers-mode 1)
  (flyspell-mode 1)
  (auto-fill-mode 1)
  (local-set-key [f5] 'org-latex-export-to-pdf))
(add-hook 'org-mode-hook 'snim2-org)

;;; Markdown.
(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\(?:\\.md\\)?\\'" . gfm-mode))
  :init
  (setq markdown-command
        (or (executable-find "multimarkdown")
            (executable-find "pandoc")
            (executable-find "markdown")
            "markdown"))
  :hook
  (markdown-mode . flyspell-mode)
  (markdown-mode . auto-fill-mode))


;; Trailing whitespace.
(setq show-trailing-whitespace t)


;; GPL license text.
(defun gpl ()
  "Insert a GPL license. Should be a comment in a program file."
  (interactive)
  (insert "Copyright (C) Sarah Mount, 2013.\n\n"
          "This program is free software; you can redistribute it and/or\n"
          "modify it under the terms of the GNU General Public License\n"
          "as published by the Free Software Foundation; either version 2\n"
          "of the License, or (at your option) any later version.\n\n"
          "This program is distributed in the hope that it will be useful,\n"
          "but WITHOUT ANY WARRANTY; without even the implied warranty of\n"
          "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"
          "GNU General Public License for more details.\n\n"
          "You should have received a copy of the GNU General Public License\n"
          "along with this program. If not, see <http://www.gnu.org/licenses/>.\n"))

;; Count words.
(defun count-words (&optional begin end)
  "Count words between BEGIN and END in a region. If no region is
  defined, count words in the buffer."
  (interactive "r")
  (let ((b (if mark-active begin (point-min)))
        (e (if mark-active end (point-max))))
    (message "Word count %s" (how-many "\\w+" b e))))


;; Un-fill region i.e. remove new lines in the selected region or buffer.
(defun unfill-region (&optional begin end)
  "Un-fill region i.e. remove new lines in the selected region or buffer."
  (interactive "r")
  (let ((start (if mark-active begin (point-min)))
        (stop  (if mark-active end   (point-max))))
    (save-excursion
      (goto-char start)
      (while (re-search-forward "\r\n" stop t)
        (replace-match " "))
      (goto-char start)
      (while (re-search-forward "\n" stop t)
        (replace-match " ")))))


(defun tabs-to-spaces (&optional begin end)
  "Replace tabs with spaces in a region."
  (interactive "r")
  (let ((start (if mark-active begin (point-min)))
        (stop  (if mark-active end   (point-max))))
    (save-excursion
      (goto-char start)
      (while (re-search-forward "\t" stop t)
        (replace-match "    ")))))


(defun four-spaces-to-tab (&optional begin end)
  "Replace four spaces with a tab in a region."
  (interactive "r")
  (let ((start (if mark-active begin (point-min)))
        (stop  (if mark-active end   (point-max))))
    (save-excursion
      (goto-char start)
      (while (re-search-forward "    " stop t)
        (replace-match "\t")))))


(defun eight-spaces-to-tab (&optional begin end)
  "Replace eight spaces with a tab in a region."
  (interactive "r")
  (let ((start (if mark-active begin (point-min)))
        (stop  (if mark-active end   (point-max))))
    (save-excursion
      (goto-char start)
      (while (re-search-forward "        " stop t)
        (replace-match "\t")))))

;;; Folding mode.
(autoload 'folding-mode "folding" "Folding mode" t)

;;; Set web browser.
(setq browse-url-browser-function 'browse-url-default-browser)

;;; Useful for text / markup editing.
(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

;;; Remove DOS newline markers.
(defun dos-to-unix ()
  "Cut all visible ^M from the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

;;; ispell multiple buffers.
;;; From: http://emacswiki.org/emacs/InteractiveSpell
(defun dired-do-ispell (&optional arg)
  (interactive "P")
  (dolist (file (dired-get-marked-files
                 nil arg
                 #'(lambda (f)
                     (not (file-directory-p f)))))
    (save-window-excursion
      (with-current-buffer (find-file file)
        (ispell-buffer)))
    (message nil)))


;;; Increment numbers in a region. By Justin Davis
;;; http://jmdavisblog.blogspot.co.uk/2013/08/a-handful-of-emacs-utilities.html
(defun inc-num-region (p m)
  "Increments the numbers in a given region"
  (interactive "r")
  (save-restriction
    (save-excursion
      (narrow-to-region p m)
      (goto-char (point-min))
      (forward-line)
      (let ((counter 1))
        (while (not (eq (point) (point-max)))
          (goto-char (line-end-position))
          (search-backward-regexp "[0-9]+" (line-beginning-position) t)
          (let* ((this-num (string-to-number (match-string 0)))
                 (new-num-str (number-to-string (+ this-num counter))))
            (replace-match new-num-str)
            (cl-incf counter)
            (forward-line)))))))
