;; Reference
;; http://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries

;; Matched patterns
;;
;; var build = "develop"

(variable_declarator
	name:(identifier) @p.assign.key
	value:(_) @p.assign.value
)

;; { Handler: apiMux }
(object
	(pair
		key: (property_identifier) @p.assign.key
		value: (_) @p.assign.value
	)
)
