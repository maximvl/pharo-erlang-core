Extension { #name : #OrderedCollection }

{ #category : #'*Erlang-Core' }
OrderedCollection >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writeList: self to: aStream.
]
