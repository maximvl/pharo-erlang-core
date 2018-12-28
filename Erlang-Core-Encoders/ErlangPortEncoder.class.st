"
Encodes Erlang ports
"
Class {
	#name : #ErlangPortEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'NewPortTag',
		'PortTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangPortEncoder class >> decode: aStream [
	"Write a list of things into a stream"
	| tag node id creation |
	
	tag := aStream next.
	node := self decodeTerm: aStream.
	id := (aStream next: 4) asInteger .
	tag = PortTag 
		ifTrue: [ creation := aStream next  ]
		ifFalse: [ creation := (aStream next: 4) asInteger ].
	
	^ ErlangPort tag: tag node: node id: id creation: creation .
]

{ #category : #converting }
ErlangPortEncoder class >> encode: aPort to: aStream [
	"Write a list of things into a stream"
	| tag |
	
	tag := aPort tag.
	
	aStream nextPut: tag.
	self encodeTerm: (aPort node) to: aStream.
	aStream nextPutAll: (aPort id asByteArrayOfSize: 4).
	
	tag = PortTag ifTrue: [ aStream nextPut: (aPort creation ). ^ self ].
	tag = NewPortTag ifTrue: [ aStream nextPutAll: ((aPort creation) asByteArrayOfSize: 4). ^ self ].
	Error signal: 'Unknown port tag: ', (tag asString).
]

{ #category : #initialization }
ErlangPortEncoder class >> initialize [

	PortTag := 102.
	NewPortTag := 89.
	
	EncodersDict at: PortTag put: self.
	EncodersDict at: NewPortTag put: self.
]
