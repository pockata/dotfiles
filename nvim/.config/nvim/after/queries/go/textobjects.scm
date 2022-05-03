;; Reference
;; http://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries

;; Matched patterns
;;
;; api:= http.Server
;; var build = "develop"
;; { Handler: apiMux }

;; keys
(short_var_declaration right:(expression_list) @p.assign.value)
(var_declaration (var_spec value:(expression_list) @p.assign.value))
(keyed_element . (literal_element (identifier)) (_) @p.assign.value)

;; values
(short_var_declaration left:(expression_list) @p.assign.key)
(var_declaration (var_spec name:(_) @p.assign.key))
(keyed_element . (literal_element (identifier) @p.assign.key))

