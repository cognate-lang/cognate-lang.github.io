(defvar style "style.css")
(defvar title "page title")

(defun page-to-url (page)
  (concatenate 'string (string-downcase (string page)) ".html"))

(defun page (name &rest contents)
  (with-open-file (stream (page-to-url name)
                          :direction :output
                          :if-does-not-exist :create
                          :if-exists :supersede)
    (format stream
"<!DOCTYPE html>
<html>
<head>
<meta charset=\"UTF-8\">
<link rel=\"stylesheet\" href=\"~a\">
<title>~a</title>
</head>
<body>
~{~a~%~}
</body>
</html>" style title contents)))

(defun large-header (contents) (format nil "<h1>~a</h1>" contents))
(defun small-header (contents) (format nil "<h2>~a</h2>" contents))

(defun text (&rest txt)
  (format nil "<div class=\"text\">~{~a~}</div>" txt))

(defun para (&rest p)
  (format nil "<p>~{~a~}</p>" p))

(defun code (filetype text)
  (with-open-file (stream "tmp" :direction :output :if-does-not-exist :create :if-exists :supersede)
    (format stream text))
  (sb-ext:run-program "/usr/bin/env"
                      (list "vim" "-E"
                            "-c" "let g:html_no_progress=1"
                            "-c" "syntax on"
                            "-c" (format nil "set ft=~a" (string-downcase (string filetype)))
                            "-c" "runtime syntax/2html.vim"
                            "-cwqa" "tmp") :pty t)
  (with-open-file (stream "tmp.html" :direction :input)
    (loop for line = (read-line stream nil)
          until (string= line "<pre id='vimCodeElement'>"))
    (let ((highlighted-code (loop for line = (read-line stream nil)
                                  until (string= line "</pre>")
                                  collect line)))
      (format nil "<div class=\"code\"><pre>~%~{~a~%~}</pre></div>" highlighted-code))))

(defun link (text url)
  (format nil "<a href=\"~a\">~a</a>" (if (symbolp url) (page-to-url url) url) text))

(defun unordered-list (&rest items)
  (format nil "<ul>~{<li>~a</li>~}</ul>" items))

(defun italic (text)
  (format nil "<i>~a</i>" text))

(defun bold (text)
  (format nil "<i>~a</i>" text))

(defun mono (text)
  (format nil "<span class=\"mono\">~a</span>" text))
