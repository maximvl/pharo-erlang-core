Extension { #name : #OrderedCollection }

{ #category : #'*Erlang-Core' }
OrderedCollection >> erlangEncoder [
	"comment stating purpose of message"

	^ #ErlangListEncoder .
]
