Extension { #name : #ErlangRef }

{ #category : #'*Erlang-Core' }
ErlangRef >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeRef: self to: aStream.
]
