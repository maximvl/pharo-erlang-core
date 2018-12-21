Extension { #name : #ErlangPid }

{ #category : #'*Erlang-Core' }
ErlangPid >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writePid: self to: aStream.
]
