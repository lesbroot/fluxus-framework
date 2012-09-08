(require mzlib/string)
    
(define (osc-repl)
  (cond ((osc-msg "/code")
         (map eval (read-from-string-all (osc 0))))
        ((osc-msg "/spawn-task")
         (let ([task-name (read (open-input-string (osc 0)))])
           (spawn-task (eval task-name) task-name)))
        ((osc-msg "/rm-task")
         (rm-task (read (open-input-string (osc 0)))))
        ((osc-msg "/rm-all-tasks")
         (rm-all-tasks)
         (spawn-task osc-repl 'osc-repl))
        ((osc-msg "/clear")
         (clear))
        ((osc-msg "/load")
         (with-handlers ([exn:fail? (lambda (exn) 'load-error)])
             (load (osc 0))))
        ((osc-msg "/ping")
         (begin (display "ping")
                (newline)))))     

(osc-source "34343")

(spawn-task osc-repl 'osc-repl)
