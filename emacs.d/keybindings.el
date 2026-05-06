;; Sarah's emacs configurator.

;; Keybindings changes.

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

(message "Keybinding configuration.")

;; buffcycle is a local elisp package for cycling through buffers.
(require 'buffcycle)

;; Use Ctrl-/ for comment / uncomment.
(defun comment-or-uncomment-region-or-line ()
  "Un/Comments the region or the current line if there's no active region."
  (interactive)
  (message "un/comment")
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))
(global-set-key (kbd "C-/") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-_") 'comment-or-uncomment-region-or-line)

;; Use the delete button in the way you would expect.
(global-set-key (kbd "<delete>") 'delete-char)
(delete-selection-mode 1)

;; Use Ctrl-Z for undo.
(global-set-key (kbd "C-z") 'undo)

;; Cycle through buffers with C-q.
(global-set-key (kbd "C-q") 'next-buffer-cycle)

;; Get online documentation with F1.
(global-set-key (kbd "<f1>") 'woman)

;; Rebind `C-x C-b'.
(global-set-key (kbd "C-x C-b") 'electric-buffer-list)

;; Full screen mode.
(global-set-key [f11] 'toggle-frame-fullscreen)

;; Move a single line of text up or down the buffer.
;; From: http://www.mygooglest.com/fni/dot-emacs.html
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (let ((col (current-column))
        start
        end)
    (beginning-of-line)
    (setq start (point))
    (end-of-line)
    (forward-char)
    (setq end (point))
    (let ((line-text (delete-and-extract-region start end)))
      (forward-line n)
      (insert line-text)
      (forward-line -1)
      (forward-char col))))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "<M-up>") 'move-line-up)
(global-set-key (kbd "<M-down>") 'move-line-down)
