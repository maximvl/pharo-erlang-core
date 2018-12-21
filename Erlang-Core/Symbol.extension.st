Extension { #name : #Symbol }

{ #category : #'*Erlang-Core' }
Symbol >> asErlangObject: aStream [
	"comment stating purpose of message"

	^ ErlangDencoder writeAtom: self to: aStream.
]
