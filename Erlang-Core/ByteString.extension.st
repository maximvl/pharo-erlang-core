Extension { #name : #ByteString }

{ #category : #'*Erlang-Core' }
ByteString >> erlangEncoder [
	"comment stating purpose of message"

	^ #ErlangListEncoder .
]
