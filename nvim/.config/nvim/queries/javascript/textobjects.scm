;; vim: ft=query
;; Reference
;; http://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries

;; Matched patterns
;;
;; var build = "develop"

(variable_declarator
	name:(_) @p.assign.key
	value:(_) @p.assign.value
)

(assignment_expression
	left: (_) @p.assign.key
	right: (_) @p.assign.value
)

;; { Handler: apiMux }
(object
	(pair
		key: (_) @p.assign.key
		value: (_) @p.assign.value
	)
)

;; return statements
(return_statement
	(_) @p.return.inner
) @p.return.outer

