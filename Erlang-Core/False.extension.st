Extension { #name : #False }

{ #category : #'*Erlang-Core' }
False >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeAtom: #false to: aStream .
]
