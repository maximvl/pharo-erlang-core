Extension { #name : #String }

{ #category : #'*Erlang-Core' }
String >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeString: self to: aStream.
]
