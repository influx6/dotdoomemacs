;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Set the default projectile search path
(setq projectile-project-search-path '("~/Lab"))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(defun add-or-switch-project-dwim (dir)
  "Let elisp do a few chores & set my hands free!"
  (interactive (list (read-directory-name "Add to known projects: ")))
  (projectile-add-known-project dir)
  (find-file dir)
  (treemacs-add-and-display-current-project))

;; Key bindings configuration
;; (global-set-key (kbd "C-c q") 'shell)
;; (global-set-key (kbd "<SPC> 1") '(other-window 1))
;; (global-set-key (kbd "SPC-2") '(other-window 2))

;; (map! "SPC m 1" '#(other-window 1))
;; (map! "SPC m 2" '#other-window 2)
;;
(defun private/treemacs-back-and-forth ()
  (interactive)
  (if (treemacs-is-treemacs-window-selected?)
      (aw-flip-window)
    (treemacs-select-window)))

(defun move-window-away-by-n (n)
  (other-window n))

(defun previous-window-away-by-1 ()
  (interactive)
  (move-window-away-by-n -1))

(defun next-window-away-by-1 ()
  (interactive)
  (move-window-away-by-n 1))

(defun split-window-vertical ()
  (interactive)
  (evil-window-vsplit))

(defun split-window-horizontal ()
  (interactive)
  (evil-window-split))

(defun named-shell ()
  "creates a shell with a given name"
  (interactive);; "Prompt\n shell name:"
  (let ((shell-name (read-string "shell name: ", nil)))
    (shell (concat "*" shell-name "*"))))

(defun to-window-by ()
  "moves to destination window based on cont"
  (interactive)
  (setq move-number (string-to-number (read-string "move by: " nil "1")))
    (message "Going to next window by: %s" move-number)
    (move-window-away-by-n move-number))

(defun in-place-shell ()
  (interactive)

  (let (
        (currentbuf (get-buffer-window (current-buffer)))
        (newbuf     (generate-new-buffer-name "*shell*"))
        )

    (generate-new-buffer newbuf)
    (set-window-dedicated-p currentbuf nil)
    (set-window-buffer currentbuf newbuf)
    (shell newbuf)
    )
  )


(map! :leader

      (:prefix-map ("z" . "alexander keyboard shorthands")

                   (:prefix-map ("w" . "window shorthand")
                        :desc "Switch to treemacs" "t" #'private/treemacs-back-and-forth
                        :desc "vsplit window" "v" #'split-window-vertical
                        :desc "hsplit window" "h" #'split-window-horizontal
                        :desc "balance/resize windows" "r" #'balance-windows
                        :desc "next window +1" "1" #'next-window-away-by-1
                        :desc "previous window -1" "2" #'previous-window-away-by-1
                        :desc "next window" "w" #'to-window-by
                    )


                   (:prefix-map ("s" . "shell shorthand")
                        :desc "clears buffer screen" "c" #'comint-clear-buffer
                        :desc "new shell in-place" "s" #'in-place-shell
                        :desc "named shell" "n" #'named-shell
                    )

        )

)
