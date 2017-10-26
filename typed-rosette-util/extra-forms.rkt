#lang turnstile

(provide for/hash
         set-member?
         tup proj C×
         (for-syntax ~C×))

(require (except-in typed/rosette #%app)
         typed/rosette/types
         (only-in typed/rosette/base-forms unsafe-assign-type)
         (only-in turnstile/examples/stlc+tup
                  tup proj [× C×] [~× ~C×])
         (prefix-in ro: rosette))

;; ----------------------------------------------------------------------------

;; Extra For Forms

;; This behaves slightly differently from the racket
;; version: the body expression must produce a 2-tuple
;; instead of using multiple values.
(define-typed-syntax for/hash
  [(_ ([x:id seq:expr] ...) body:expr) ≫
   [⊢ [seq ≫ seq- ⇒ (~CSequenceof τ_x)] ...]
   [[x ≫ x- : τ_x] ... ⊢ body ≫ body- ⇒ (~C× τ_key τ_val)]
   --------
   [⊢ (ro:for/hash ([x- seq-] ...) (apply- values- body-))
      ⇒ (CHashof τ_key τ_val)]])

;; ----------------------------------------------------------------------------

;; Lists

(define set-member?
  (unsafe-assign-type ro:set-member? :
                      (C→ (CListof CAny) CAny CBool)))

;; ----------------------------------------------------------------------------

