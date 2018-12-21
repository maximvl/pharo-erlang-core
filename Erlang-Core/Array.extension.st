Extension { #name : #Array }

{ #category : #'*Erlang-Core' }
Array >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeTuple: self to: aStream.
]
