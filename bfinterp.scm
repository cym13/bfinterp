#lang racket
;
; LICENSE
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program. If not, see <http://www.gnu.org/licenses/>.
; END_OF_LICENSE
;
; This is my first attempt at building a brainfuck interpreter with a
; functionnal approach.
;
; It is in a debugging state right now.

(define (inc a) (+ a 1))
(define (dec a) (- a 1))

(define (nth n l)
    (cond ((eq? l '()))
          ((= n 0) (car l))
          (#T (nth (dec n) (cdr l)))))

(define (set-list len fill-char)
    (if (= len 0)
        '()
        (cons fill-char (set-list (dec len) fill-char))))

; Default environment spec
(define (init-env mem-len) (list (list 'prog-p      0)
                                 (list 'mem-p       0)
                                 (list 'mem         (set-list mem-len 0))
                                 (list 'loop-buffer '())))

(define (get-att attname object)
    (cond ((eq? object '()) '())
          ((eq? (caar object) attname) (cadar object))
          (#T (get-att attname (cdr object)))))

(define (set-att attname new-val object)
    (define (set-att- attname new-val object checked)
        (cond ((eq? object '()) (reverse checked))
              ((eq? (caar object) attname)
                    (cons (cons attname (list new-val))
                          checked))
              (#T (set-att- attname
                            new-val
                            (cdr object)
                            (cons (car object) checked)))))
    (set-att- attname new-val object '()))

(define (curinst env prog) (nth (get-att 'prog-p env) prog))

(define (apply-on-mem index mem fun)
    (define (apply-on-mem- index mem fun rem)
        (cond ((eq? mem '()) (reverse rem))
              ((= index 0) (apply-on-mem- (dec index)
                                          (cdr mem)
                                          (cons (fun (car mem)) rem)
                                          '()))
              (#T (apply-on-mem- (dec index)
                                 (cdr mem)
                                 (cons (car mem) rem)
                                 '()))))
    (apply-on-mem- index mem fun '()))

(define (set-mem index n mem)
    (apply-on-mem index
                  mem
                  (lambda (x) n)))

(define (add-mem index n mod mem)
    (apply-on-mem index
                  mem
                  (lambda (x) (modulo (+ x n) mod))))

(define (inc-mem index mod mem) (add-mem index  1 mod mem))
(define (dec-mem index mod mem) (add-mem index -1 mod mem))

; Example: (update-env env (('prog-p (inc (get-att 'prog-p env)))
;                           ('mem-p  (inc (get-att 'mem-p  env)))))
(define (update-env env mods)
    (cond ((eq? mods '()) (set-att 'prog-p (inc (get-att 'prog-p env)) env))
          (#T (update-env (set-att (caar mods) (cadar mods) env)
                          (cdr mods)))))

(define (bfinterp prog mem-len)
    (let
     ((prog-length (length prog)))
     (define (interp env)
         (cond ((= prog-length (get-att 'prog-p env)))
               ((eq? '> (curinst env prog))
                    (interp (update-env env
                             '((mem-p (modulo (inc (get-att 'mem-p env))
                                               mem-len))))))
               ((eq? '< (curinst env prog))
                    (interp (update-env env
                             '((mem-p (modulo (dec (get-att 'mem-p env))
                                               mem-len))))))
               ((eq? '+ (curinst env prog))
                    (interp (update-env env
                             '((mem (inc-mem (get-att 'mem-p env)
                                              255
                                              (get-att 'mem env)))))))
               ((eq? '- (curinst env prog))
                    (interp (update-env env
                             '((mem (dec-mem (get-att 'mem-p env)
                                              255
                                              (get-att 'mem env)))))))
               ((eq? '\[ (curinst env prog))
                    (interp (update-env env
                             '((loop-buffer (cons (get-att 'prog-p env)
                                                   (get-att 'loop-buffer
                                                             env)))))))
               ((eq? '\] (curinst env prog))
                    (interp (update-env env
                             '((prog-p      (car (get-att 'loop-buffer env)))
                               (loop-buffer (cdr (get-att 'loop-buffer
                                                            env)))))))
               ((eq? '\. (curinst env prog))
                    (interp (update-env env
                             '((mem (set-mem (get-att 'mem-p env)
                                              (read-char)
                                              'mem))))))
               ((eq? '\, (curinst env prog))
                    (printf "~c" (integer->char (nth (get-att 'mem-p env)
                                                     (get-att 'mem   env))))
                    (interp (update-env env '())))))
    (interp (init-env mem-len))))

(define (main)
   (printf "Enter program:~n")
   (bfinterp (read) 30000))

(main)
