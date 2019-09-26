Class {
	#name : #ErlangConnection,
	#superclass : #Object,
	#instVars : [
		'socket',
		'stream',
		'host',
		'port'
	],
	#category : #'Erlang-Distribution'
}

{ #category : #'as yet unclassified' }
ErlangConnection class >> connectTo: aHost withPort: aPort [
	"comment stating purpose of message"

	^ (self new) connectTo: aHost withPort: aPort.
]

{ #category : #accessing }
ErlangConnection >> connectTo: aHost withPort: aPort [
	host := aHost.
	port := aPort.
	
	socket := Socket newTCP .
	socket connectTo: (NetNameResolver addressForName: host ) port: port.
	
	stream := SocketStream on: socket.
	stream binary.
]

{ #category : #accessing }
ErlangConnection >> inModule: aMod callfunction: aFun withArgs: someArgs [

	| msg respSize resp |
	msg := ErlangTermEncoder asByteArray: { aMod . aFun . someArgs asOrderedCollection  }.
	stream nextPutAll: ((msg size + 1) asByteArrayOfSize: 2).
	stream nextPut: 131.
	stream nextPutAllFlush: msg.
	
	respSize := (stream next: 2) asInteger .
	respSize ifNil: [ ^ nil ].
	stream skip: 1.
	resp := stream next: (respSize - 1).
	^ ErlangTermEncoder fromByteArray: resp.

	
]
