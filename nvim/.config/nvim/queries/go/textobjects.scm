;; vim: ft=query
;; Reference
;; http://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries

;; Variable assignments
;; api:= http.Server
;; var build = "develop"
;; { Handler: apiMux }

(short_var_declaration
	left:(expression_list) @p.assign.key
	right:(expression_list) @p.assign.value
)
(var_declaration
	(var_spec
		name:(_) @p.assign.key
		value:(expression_list) @p.assign.value
))

(keyed_element
	.
	(literal_element) @p.assign.key
	(_) @p.assign.value
)

(assignment_statement
	left: (expression_list) @p.assign.key
	right: (_) @p.assign.value
)

;; Block scopes if/else, for
(if_statement
	consequence: (block) @p.scope
	alternative: (
		(if_statement
		  consequence: (block) @p.scope
		  )?
		(block)? @p.scope
	)
)

(for_statement
	body: (block) @p.scope
)

