; extends
; Raise priority only for keys and values inside go_tags so they beat LSP/go string paint.

;((identifier) @variable
((identifier) @attribute
  (#set! "priority" 130))

((statement_content) @string
  (#set! "priority" 130))
