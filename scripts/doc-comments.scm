(source_file
  (multiline_comment)? @doc
  .
  (statement
    (identifier) @def (#eq? @def "Def")
    .
    (identifier) @function) @definition
)
