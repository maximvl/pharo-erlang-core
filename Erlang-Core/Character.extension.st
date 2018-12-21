Extension { #name : #Character }

{ #category : #'*Erlang-Core' }
Character >> asErlangObject: aStream [
	"comment stating purpose of message"

	( self asInteger ) asErlangObject: aStream .
]
