Extension { #name : #WideSymbol }

{ #category : #'*Erlang-Core' }
WideSymbol >> erlangEncoder [
	"comment stating purpose of message"

	^ #ErlangAtomUtfEncoder .
]
