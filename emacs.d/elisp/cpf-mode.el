;;; cpf-mode.el -- major mode for viewing clones in Clone Pair Format
;;;
;;; Copyright (c) 2003, Stefan Bellon, Daniel Simon and Gunther Vogel
;;; All rights reserved.
;;;
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;;
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * The names of the contributors may not be used to endorse or promote
;;;       products derived from this software without specific prior written
;;;       permission.
;;;
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.

(defvar cpfm-version "0.14" "Version of cpf-mode.")

;;; Installation:
;;;
;;;   To install, copy this file into some directory (let's refer to it
;;;   as CPF_MODE_DIR) and put the following three lines into your
;;;   ~/.emacs file:
;;;
;;;     (add-to-list 'load-path "CPF_MODE_DIR")
;;;     (autoload 'cpf-mode "cpf-mode")
;;;     (setq auto-mode-alist (cons '("\\.cpf\\'" . cpf-mode) auto-mode-alist))
;;;
;;; Usage:
;;;
;;;   Just load a file in Clone Pair Format with extension .cpf as usual
;;;   (C-x C-f) and this mode gets entered. Pressing RET over a line
;;;   opens that particular clone in a clone view frame.
;;;
;;;   The colours are as follows:
;;;       Red   => Type 1 Clone
;;;       Blue  => Type 2 Clone
;;;       Green => Type 3 Clone
;;;
;;;   When displaying the first clone pair per buffer, then you have to
;;;   enter the base path of the source code (ignore this if you have only
;;;   absolute paths in your CPF file, it's relevant if you relative paths
;;;   there). If you entered the wrong base path, you can change the base
;;;   path for the current buffer with C-c C-b.

;;; The code itself:

(require 'cl)

(defvar *CLONE-MAIN-FRAME* nil)
(defvar *CLONE-DISPLAY-FRAME* nil)
(defvar *CLONE1-WINDOW* nil)
(defvar *CLONE2-WINDOW* nil)
(defvar *CLONE1-BUFFER* nil)
(defvar *CLONE2-BUFFER* nil)
(defvar *CLONE-BASEPATH* nil)
(defvar *CLONE-CURRENT-BUFFER* nil)
(defvar *CLONE-CURRENT-START* nil)
(defvar *CLONE-CURRENT-END* nil)
(defvar *CLONE-WINDOW-VERTICALLY* nil)

(defface Face-HL
  '((((class color)) (:foreground "white" :background "blue"))
    (t (:inverse-video t)))
  "Standard Face for highlighting Marks.")

(defface Face-T1
  '((((class color)) (:foreground "black" :background "sienna1"))
    (t (:inverse-video t)))
  "Face for highlighting clones of type 1.")

(defface Face-T2
  '((((class color)) (:foreground "black" :background "LightBlue2"))
    (t (:inverse-video t)))
  "Face for highlighting clones of type 2.")

(defface Face-T3
  '((((class color)) (:foreground "black" :background "DarkOliveGreen2"))
    (t (:inverse-video t)))
  "Face for highlighting clones of type 3.")

(defface Face-CS
  '((((class color)) (:foreground "black" :background "gray80"))
    (t (:inverse-video t)))
  "Face for highlighting corresponding codesnippets.")

(setq face-list '(Face-HL Face-T1 Face-T2 Face-T3 Face-CS))

(defvar cpfm-mode-map () "Keymap used in CPF mode.")

(when (not cpfm-mode-map)
  (setq cpfm-mode-map (make-sparse-keymap))
  (define-key cpfm-mode-map [mouse-1] 'cpfm-highlight-all-snippets-at-mouse)
  (define-key cpfm-mode-map [mouse-2] 'cpfm-parse-line-at-mouse)
  (define-key cpfm-mode-map (read-kbd-macro "M-RET")   'cpfm-highlight-all-snippets-in-file)
  (define-key cpfm-mode-map (read-kbd-macro "P")       'cpfm-previous-clone-file)
  (define-key cpfm-mode-map (read-kbd-macro "N")       'cpfm-next-clone-file)
  (define-key cpfm-mode-map (read-kbd-macro "p")       'cpfm-previous-clone)
  (define-key cpfm-mode-map (read-kbd-macro "n")       'cpfm-next-clone)
  (define-key cpfm-mode-map (read-kbd-macro "RET")     'cpfm-parse-line)
  (define-key cpfm-mode-map (read-kbd-macro "C-c C-h") 'cpfm-split-horizontally)
  (define-key cpfm-mode-map (read-kbd-macro "C-c C-v") 'cpfm-split-vertically)
  (define-key cpfm-mode-map (read-kbd-macro "C-c C-t") 'cpfm-sort-buffer-by-type)
  (define-key cpfm-mode-map (read-kbd-macro "C-c C-s") 'cpfm-sort-buffer-by-field)
  (define-key cpfm-mode-map (read-kbd-macro "C-c C-r") 'cpfm-sort-buffer-r)
  (define-key cpfm-mode-map (read-kbd-macro "C-c C-b") 'cpfm-set-basepath))

(defun cpfm-split-horizontally ()
  (interactive)
  (setq *CLONE-WINDOW-VERTICALLY* nil))

(defun cpfm-split-vertically ()
  (interactive)
  (setq *CLONE-WINDOW-VERTICALLY* 't))

(defun cpfm-moveto-clone-file (dir)
  "Move in direction DIR by DIR steps to the next clone file."
  (interactive "nStep: \n")
  (move-to-column 0)
  (let ((file (read (current-buffer))))
    (forward-line dir)
    (while (equal file (read (current-buffer))) (forward-line dir)))
  (move-to-column 0))

(defun cpfm-next-clone-file ()
  (interactive)
  (cpfm-moveto-clone-file 1)
  (cpfm-parse-line))

(defun cpfm-previous-clone-file ()
  (interactive)
  (cpfm-moveto-clone-file -1)
  (cpfm-parse-line))

(defun cpfm-next-clone ()
  "Move cursor to next clone pair."
  (interactive)
  (forward-line 1)
  (cpfm-parse-line))

(defun cpfm-previous-clone ()
  "Move cursor to previous clone pair."
  (interactive)
  (forward-line -1)
  (cpfm-parse-line))

(defun cpfm-parse-line-at-mouse (event)
  "Navigate clone snippets at mouse point"
  (interactive "e")
  (mouse-set-point event)
  (save-excursion
    (cpfm-parse-line)))

(defun cpfm-sort-buffer-by-type ()
  "Sort CPF buffer by type, i.e. field 7"
  (interactive)
  (cpfm-sort-buffer 7))

(defun cpfm-sort-buffer-by-field (field)
  "Sort CPF buffer according to values in field FIELD"
  (interactive "nField number: \n")
  (cpfm-sort-buffer field))

(defun cpfm-sort-buffer (field &optional reverse-p)
  "Sort the buffer by field FIELD; if REVERSE-P is non-nil, reverse buffer"
  (setq buffer-read-only nil)
  (let ((old-x-pointer-shape x-pointer-shape))
    (setq x-pointer-shape x-pointer-watch)
    (set-mouse-color "black")
    (if (or (= field 1) (= field 4)) ;; these are the filenames
	(sort-fields field (point-min) (point-max))
      (sort-numeric-fields field (point-min) (point-max)))
    (if reverse-p (reverse-region (point-min) (point-max)))
    (setq x-pointer-shape old-x-pointer-shape)
    (set-mouse-color "black"))
  (set-buffer-modified-p nil)
  (setq buffer-read-only t))

(defun cpfm-sort-buffer-r (field)
  "Description see cpfm-sort-buffer. Additionally reverts sort"
  (interactive "nField number: \n")
  (cpfm-sort-buffer field t))

(defun cpfm-highlight-all-snippets-at-mouse (event)
  (interactive "e")
  (save-excursion
    (mouse-set-point event)
    (while (not (or (equal ?\t (char-before))
		    (equal ?\n (char-before))))
      (forward-char -1))
    (let ((file (read (current-buffer))))
      (if (symbolp file)
	  (cpfm-highlight-all-snippets (symbol-name file))))))

(defun cpfm-highlight-all-snippets-in-file (file)
  "Show all snippets in file FILE"
  (interactive "fThe file to highlight the clones: \n")
  (cpfm-highlight-all-snippets file))

(defun cpfm-highlight-all-snippets (file)
  "Show all clone snippets for file FILE."
  (setq *CLONE-CURRENT-BUFFER* (current-buffer))
  (unless *CLONE-BASEPATH* (call-interactively 'cpfm-set-basepath))
  (unless (frame-live-p *CLONE-DISPLAY-FRAME*)
    (setq *CLONE-DISPLAY-FRAME* (make-frame)))
  (cpfm-remove-highlight-in-cpf-buffer)
  (let ((old-x-pointer-shape x-pointer-shape))
    (save-excursion
      (move-to-column 0)
      (setq x-pointer-shape x-pointer-watch)
      (set-mouse-color "black")
      (cpfm-for-all-files-with-name file)
      (select-frame *CLONE-MAIN-FRAME*)
      (setq x-pointer-shape old-x-pointer-shape)
      (set-mouse-color "black"))))

(defun cpfm-for-all-files-with-name (filename)
  "lookup all code snippet positions in file FILENAME"
  ;; collect positions
  (select-frame *CLONE-MAIN-FRAME*)
  (switch-to-buffer *CLONE-CURRENT-BUFFER*)
  (goto-line 0)
  (let (positions
	actual-file1 actual-file2
	start-line1 end-line1
	start-line2 end-line2
	clone-type)
    (defun append-if-not-member (file start end clone-type)
      (if (and (equal file filename)
	       (not (member (list start end clone-type) positions)))
	  (setq positions
		(append (list (list start end clone-type)) positions))))

    ;; now scan all lines in cpf buffer for file FILENAME and read the
    ;; positions into the list POSITIONS. Each pair (start-line end-line)
    ;; is listed once
    (while (progn
	     (move-to-column 0)
	     (setq actual-file1 (symbol-name (read (current-buffer))))
	     (setq start-line1  (read (current-buffer)))
	     (setq end-line1    (read (current-buffer)))
	     (setq actual-file2 (symbol-name (read (current-buffer))))
	     (setq start-line2  (read (current-buffer)))
	     (setq end-line2    (read (current-buffer)))
	     (setq clone-type   (read (current-buffer)))
	     (append-if-not-member actual-file1 start-line1
				   end-line1 clone-type)
	     (append-if-not-member actual-file2 start-line2
				   end-line2 clone-type)
	     (forward-line 1)
	     (< (point) (point-max))))

    ;; now we have all snippets in positions and we start to
    ;; highlight all of them
    ;; prepare frame and buffer
    (select-frame *CLONE-DISPLAY-FRAME*)
    (delete-other-windows)
    (if (file-accessible-directory-p *CLONE-BASEPATH*) (cd *CLONE-BASEPATH*))
    (switch-to-buffer (find-file-noselect filename t nil nil))
    (setq buffer-read-only nil)
    (mapc 'cpfm-highlight-snippet positions)
    (set-buffer-modified-p nil)
    (setq buffer-read-only 't))
  (goto-line (point-min)))

(defun cpfm-highlight-snippet (triple)
  "Highlight a single snippet; expects triple to be a list like
  (start-line end-line type)"
  (let ((start (car triple))
	(end (cadr triple))
	(type (caddr triple)))
    (goto-line (+ end 1)) (move-to-column 0) (setq end (point))
    (goto-line start) (setq start (point))
    (overlay-put (make-overlay start end) 'face (nth type face-list))))

(defun cpfm-set-basepath (path)
  "Sets the base path. This is where we look for the clone files."
  (interactive "DBase path: \n")
  (setq *CLONE-BASEPATH* path))

(defun cpfm-parse-line ()
  (interactive)
  (move-to-column 0)
  (unless *CLONE-BASEPATH* (call-interactively 'cpfm-set-basepath))
  (cpfm-show-clone (read (current-buffer))
		   (read (current-buffer))
		   (read (current-buffer))
		   (read (current-buffer))
		   (read (current-buffer))
		   (read (current-buffer))
		   (read (current-buffer))))

(defun cpfm-set-overlay (start end face)
  (interactive)
  (setq buffer-read-only nil)
  (goto-line (+ end 1))
  (move-to-column 0)
  (setq end-line (point))
  (goto-line start)
  (setq start-line (point))
  (overlay-put (make-overlay start-line end-line) 'face face)
  (set-buffer-modified-p nil)
  (setq buffer-read-only 't))

(defun cpfm-show-snippet (nr window buffer file1 from1 to1 file2 from2 to2 type)
  (interactive)
  (let (start-line end-line)

    (if (buffer-live-p (eval buffer))
	(kill-buffer (eval buffer)))
    (select-window window)
    (if (file-accessible-directory-p *CLONE-BASEPATH*)
	(cd *CLONE-BASEPATH*))
    (set buffer (find-file-noselect (symbol-name file1) t nil nil))
    (switch-to-buffer (eval buffer))
    (set-visited-file-name (concat (buffer-file-name) "-"
				   (prin1-to-string nr)))
    (if (equal file1 file2)
	(cpfm-set-overlay from2 to2 'Face-CS))
    (cpfm-set-overlay from1 to1 (nth type face-list))))

(defun cpfm-remove-highlight-in-cpf-buffer ()
  (if (and *CLONE-CURRENT-START* *CLONE-CURRENT-END* *CLONE-CURRENT-BUFFER*)
      (progn
	(let ((*CLONE-TMP-BUFFER* (current-buffer)))
	  (switch-to-buffer *CLONE-CURRENT-BUFFER*)
	  (setq buffer-read-only nil)
	  (remove-text-properties *CLONE-CURRENT-START*
				  *CLONE-CURRENT-END*
				  (list 'face)
				  *CLONE-CURRENT-BUFFER*)
	  (set-buffer-modified-p nil)
	  (setq buffer-read-only 't)
	  (switch-to-buffer *CLONE-TMP-BUFFER*)))))

(defun cpfm-show-clone (file1 from1 to1 file2 from2 to2 type)
  "Display select clone."
  (cpfm-remove-highlight-in-cpf-buffer)
  (setq *CLONE-CURRENT-BUFFER* (current-buffer))
  (setq *CLONE-CURRENT-END* (point))
  (move-to-column 0)
  (setq *CLONE-CURRENT-START* (point))
  (setq buffer-read-only nil)
  (put-text-property *CLONE-CURRENT-START*
		     *CLONE-CURRENT-END*
		     'face (nth type face-list)
		     *CLONE-CURRENT-BUFFER*)
  (set-buffer-modified-p nil)
  (setq buffer-read-only 't)

  (unless (frame-live-p *CLONE-DISPLAY-FRAME*)
    (setq *CLONE-DISPLAY-FRAME* (make-frame)))
  (select-frame *CLONE-DISPLAY-FRAME*)

  ;;; create window 1
  (if (window-live-p *CLONE1-WINDOW*)
      (delete-other-windows *CLONE1-WINDOW*))
  (setq *CLONE1-WINDOW* (selected-window))
  (if (and (not (eq (window-buffer *CLONE1-WINDOW*)
		    *CLONE1-BUFFER*))
	   (buffer-live-p *CLONE1-BUFFER*))
      (progn
	(select-window *CLONE1-WINDOW*)
	(switch-to-buffer *CLONE1-BUFFER*)))

  ;;; create window 2
  (if *CLONE-WINDOW-VERTICALLY*
      (setq *CLONE2-WINDOW* (split-window-vertically))
      (setq *CLONE2-WINDOW* (split-window-horizontally)))
  (if (and (not (eq (window-buffer *CLONE2-WINDOW*)
		    *CLONE2-BUFFER*))
	   (buffer-live-p *CLONE2-BUFFER*))
      (progn
	(select-window *CLONE2-WINDOW*)
	(switch-to-buffer *CLONE2-BUFFER*)))

  (cpfm-show-snippet 1 *CLONE1-WINDOW* '*CLONE1-BUFFER*
		     file1 from1 to1 file2 from2 to2 type)
  (cpfm-show-snippet 2 *CLONE2-WINDOW* '*CLONE2-BUFFER*
		     file2 from2 to2 file1 from1 to1 type)

  (select-frame *CLONE-MAIN-FRAME*)
  (move-to-column 0))

(add-hook 'cpf-mode-hook
	  '(lambda ()
	     (setq *CLONE-MAIN-FRAME* (selected-frame))
	     (setq *CLONE-BASEPATH* nil)))

(defun cpf-mode ()
  "Major mode for viewing clones in Clone Pair Format
\\{cpfm-mode-map}"
  (kill-all-local-variables)
  (setq buffer-read-only 't)
  (use-local-map cpfm-mode-map)
  (setq mode-name "CPF"
	major-mode 'cpf-mode)
  (run-hooks 'cpf-mode-hook))
(provide 'cpf-mode)

;;; End of cpf-mode.el
