;; extends
;; vim: ft=query
;; Reference
;; http://tree-sitter.github.io/tree-sitter/using-parsers#pattern-matching-with-queries

;; Matched patterns
;;
;; var build = "develop"

; (variable_declarator
; 	name: (_) @p.assign.key
; 	value: (_) @p.assign.value
; )
;
;; { Handler: apiMux }
(object
  (pair
    key: (_) @assignment.lhs
    value: (_) @assignment.inner @assignment.rhs) @assignment.outer)

;; return statements
(return_statement
	(_) @return.inner
) @return.outer

;; xml attr
(jsx_element
  open_tag: (jsx_opening_element
			  attribute: (jsx_attribute
						   (property_identifier)
						   (_)? @p.jsxAttrVal
						   )? @p.jsxAttr
			  )
  ) @p.htmltag.outer

;; xml attr
(jsx_self_closing_element
	attribute: (jsx_attribute
				(property_identifier)
				(_)? @p.jsxAttrVal
				) @p.jsxAttr
	) @p.htmltag.outer

; (jsx_fragment (_) @p.htmltag.inner) @p.htmltag.outer
; (jsx_fragment) @p.htmltag.outer


; cursor on "NewBuilding", hit viv and highlights the whole useState(...)
	; // other features
	; const [otherFeatures, setOtherFeatures] = useState(
	; 	/** @type {{-readonly [key in keyof typeof OtherFeaturesType]:boolean}} */({
	; 		[OtherFeaturesType.Maisonette]: d?.apartment_other_aparmtnetMaisonette ?? false,
	; 		[OtherFeaturesType.Attic]: d?.apartment_other_attic ?? false,
	; 		[OtherFeaturesType.HighCeiling]: d?.apartment_other_highCeiling ?? false,
	; 		[OtherFeaturesType.PassThroughRooms]: d?.apartment_other_passThroughRooms ?? false,
	; 		[OtherFeaturesType.WithMortgage]: d?.apartment_other_withMortgage ?? false,
	; 		[OtherFeaturesType.Yard]: d?.apartment_other_yard ?? false,
	; 		[OtherFeaturesType.SharedYard]: d?.apartment_other_sharedYard ?? false,
	; 		[OtherFeaturesType.ClosedComplex]: d?.apartment_other_closedComplex ?? false,
	; 		[OtherFeaturesType.OuterInsulation]: d?.apartment_other_outerInsulation ?? false,
	; 		[OtherFeaturesType.Sauna]: d?.apartment_other_outerInsulation ?? false,,
	; 		[OtherFeaturesType.NewBuilding]: "NewBuilding",
	; 		[OtherFeaturesType.WinterGarden]: "WinterGarden",
	; 		[OtherFeaturesType.GroundFloor]: "GroundFloor",
	; 		[OtherFeaturesType.Fireplace]: "Fireplace",
	; 		[OtherFeaturesType.Jacuzzi]: "Jacuzzi",
	; 		[OtherFeaturesType.Bathtub]: "Bathtub",
	; 	})
	; );
	;
