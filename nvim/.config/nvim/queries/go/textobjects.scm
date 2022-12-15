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

(func_literal) @function.outer
(method_declaration) @function.outer
(function_declaration) @function.outer

;; return
;; based on https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/ecma/textobjects.scm#L90
(return_statement
  (expression_list
	"," @_start .
	(_) @p.return.inner
	(#make-range! "p.return.outer" @_start @p.return.inner)
	)
  )

(return_statement
  (expression_list
														   . (_) @p.return.inner
	. ","? @_end
	(#make-range! "p.return.outer" @p.return.inner @_end)
  )
)
