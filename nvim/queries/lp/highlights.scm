; Keywords
(sense) @keyword.directive

(subject_to_keyword) @keyword.conditional

(bounds_keyword) @keyword.type

(generals_keyword) @keyword.type

(integers_keyword) @keyword.type

(binaries_keyword) @keyword.type

(semi_continuous_keyword) @keyword.type

(sos_keyword) @keyword.type

(end_marker) @keyword.return

(free_keyword) @keyword.modifier

; SOS type
(sos_type) @type

; Operators
(comparison_operator) @operator

(linear_expression
  [
    "+"
    "-"
  ] @operator)

; Signed numeric values in constraints/bounds
(constraint
  [
    "+"
    "-"
  ] @operator)

(bound_declaration
  [
    "+"
    "-"
  ] @operator)

(sos_entry
  [
    "+"
    "-"
  ] @operator)

; Numbers
(number) @number

; Infinity
(infinity) @constant.builtin

; Labels / names
(objective_name) @label

(constraint_name) @label

(sos_name) @label

; Variables
(term
  (identifier) @variable)

(bound_declaration
  (identifier) @variable)

(generals_section
  (identifier) @variable)

(integers_section
  (identifier) @variable)

(binaries_section
  (identifier) @variable)

(semi_continuous_section
  (identifier) @variable)

(sos_entry
  (identifier) @variable)

; Comments
(line_comment) @comment

(block_comment) @comment
