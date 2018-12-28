Extension { #name : #WideString }

{ #category : #'*Erlang-Core' }
WideString >> erlangEncoder [
	"Represent wide string as a list of character codes"

	^ #ErlangListEncoder .
]
