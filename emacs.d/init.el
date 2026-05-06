;; Sarah's emacs configurator.

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

(message "Loading custom Emacs configuration.")

(require 'cl-lib)

;;; Sort out load-path.
(setq load-path (cons "~/.emacs.d/elisp/" load-path))

;;; Package setup.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;; use-package is built into Emacs 29.
(require 'use-package)
(setq use-package-always-ensure t)

;;; Say no to condescension.
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; British English.
(setq ispell-dictionary "british")

;; European dates.
(setq calendar-date-style "european")

;; Save history between sessions.
(savehist-mode 1)

;; Desktop session.
(desktop-save-mode 1)

;; Save point position between sessions.
(save-place-mode 1)

;; Save backup files in a global directory, to avoid littering the
;; filesystem with *~ files.
(defun make-backup-file-name (file)
  (let ((dir (expand-file-name "~/.emacs.d/autosave/")))
    (unless (file-directory-p dir)
      (make-directory dir t))
    (concat dir (file-name-nondirectory file) "~")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Load subfiles.                                                        ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-file "~/.emacs.d/editing.el")
(load-file "~/.emacs.d/latex-config.el")
(load-file "~/.emacs.d/programming.el")
(load-file "~/.emacs.d/interwebs.el")
(load-file "~/.emacs.d/keybindings.el")
(load-file "~/.emacs.d/look-and-feel.el")

;; Private data, not to be pushed to github.com
(when (file-exists-p "~/.emacs.d/private.el")
  (load-file "~/.emacs.d/private.el"))

;; Remove toolbar.
(message "Removing tool bar")
(tool-bar-mode -1)
