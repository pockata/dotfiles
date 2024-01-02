;; extends
;; vim: ft=query
;; Reference
;; http://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries

;; Variable assignments
;; api:= http.Server
;; var build = "develop"
;; { Handler: apiMux }

(short_var_declaration
	left:(expression_list) @assignment.lhs
	right:(expression_list) @assignment.rhs
)
(var_declaration
	(var_spec
		name:(_) @assignment.lhs
		value:(expression_list) @assignment.rhs
))

(keyed_element
	.
	(literal_element) @assignment.lhs
	(_) @assignment.rhs
)

(assignment_statement
	left: (expression_list) @assignment.lhs
	right: (_) @assignment.rhs
)

;; Block scopes if/else, for
(if_statement
	consequence: (block) @scope
	alternative: (
		(if_statement
		  consequence: (block) @scope
		  )?
		(block)? @scope
	)
)

(for_statement
	body: (block) @scope
)

(func_literal) @function.outer
(method_declaration) @function.outer
(function_declaration) @function.outer

;; return
;; based on https://github.com/nvim-treesitter/nvim-treesitter-textobjects/blob/master/queries/ecma/textobjects.scm#L90

(return_statement
  (expression_list
	"," @_start .
	(_) @return.inner
	(#make-range! "return.outer" @_start @return.inner)
	)
  )

(return_statement
  (expression_list
	. (_) @return.inner
	. ","? @_end
	(#make-range! "return.outer" @return.inner @_end)
	)
  )
