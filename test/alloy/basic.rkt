#lang racket

(require "../../ocelot.rkt" "../../lib/alloy.rkt" rackunit)
(require (only-in typed/rosette/base-forms
                  unsafe-assign-type
                  [define define:]))

; declare signatures
(define-sig Platform)
(define-sig Man
  [ceiling : Platform]
  [floor : Platform]
  [between : Platform Platform])

(define: Man* (unsafe-assign-type Man : Node/Expr))

; should be trivially sat
(check-true
 (alloy-run (in Man Man) (scope 5)))

; can be made true if Man is empty
(alloy-fact (in Man Platform))
(check-true
 (alloy-run (in Man Man) (scope 5)))

; can't be true if Man in Platform
(alloy-fact (some Man*))
(check-false
 (alloy-run (in Man Man) (scope 5)))

(clear-alloy-facts!)

; (in Man Platform) => (no Man)
(alloy-fact (in Man Platform))
(check-true
 (alloy-check (no Man*) (scope 5)))
