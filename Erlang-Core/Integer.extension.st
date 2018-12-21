Extension { #name : #Integer }

{ #category : #'*Erlang-Core' }
Integer >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeInteger: self to: aStream .
]
