Extension { #name : #ByteSymbol }

{ #category : #'*Erlang-Core' }
ByteSymbol >> erlangEncoder [
	"comment stating purpose of message"

	^ #ErlangAtomUtfEncoder  .
]
