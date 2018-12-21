Extension { #name : #ErlangPort }

{ #category : #'*Erlang-Core' }
ErlangPort >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writePort: self to: aStream.
]
