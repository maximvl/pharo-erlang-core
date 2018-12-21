Extension { #name : #True }

{ #category : #'*Erlang-Core' }
True >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeAtom: #true to: aStream .
]
