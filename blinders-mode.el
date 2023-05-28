;;; blinders-mode.el --- Mode for showing only a few lines of the buffer at a time  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Ariel Raudsepp

;; Author: Ariel Raudsepp <ariel.raudsepp@gmail.com>
;; URL: https://github.com/arielraudsepp/blinders-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.3"))
;; Keywords: convenience
;; Summary: Limits the visible buffer to one line at a time

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Blinders mode is a minor mode that hides all but a few lines of the buffer.

;;; Code:

(defgroup blinders nil
  "Put on your blinders so you can focus on a small number of lines at a time"
  :group 'convenience)

(defun blinders-mode--remove-blinders ()
  (interactive)
  (remove-overlays (point-min) (point-max) 'category 'blinders))

(defun blinders-mode--refresh-blinders ()
  ;; hide buffer
  (let ((before-ov (make-overlay (point-min)
                                 (line-beginning-position 0)))
        (after-ov (make-overlay (line-end-position 2)
                                (point-max))))
    (blinders-mode--remove-blinders)
    (overlay-put before-ov 'category 'blinders)
    (overlay-put before-ov 'face 'blinders-hidden-face)
    (overlay-put after-ov 'category 'blinders)
    (overlay-put after-ov 'face 'blinders-hidden-face)))

(define-minor-mode blinders-mode
  "Mode for showing only a few lines of the buffer at a time"
  :init-value nil
  (if blinders-mode
      (progn
        (defface blinders-hidden-face
          (list (list t (list :background (face-attribute 'default :background)
                              :foreground (face-attribute 'default :background))))
          "blinders-mode hidden face"
          :group 'blinders)
        (setq-local post-command-hook (cons 'blinders-mode--refresh-blinders post-command-hook)))
    (progn
      (setq-local post-command-hook (delete 'blinders-mode--refresh-blinders post-command-hook))
      (blinders-mode--remove-blinders))))

(provide 'blinders-mode)
;;; blinders-mode.el ends here
