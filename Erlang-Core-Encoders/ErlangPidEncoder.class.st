"
Pid encoder
"
Class {
	#name : #ErlangPidEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'NewPidTag',
		'PidTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangPidEncoder class >> decode: aStream [
	"Write a list of things into a stream"
	| tag node creation serial id |
	
	tag := aStream next.
	node := self decodeTerm: aStream.
	id := (aStream next: 4) asInteger .
	serial := (aStream next: 4) asInteger .
	
	tag = PidTag ifTrue: [ creation := aStream next . ].
	tag = NewPidTag ifTrue: [ creation := (aStream next: 4) asInteger ].
	creation ifNil: [ Error signal: 'Unsupported pid tag: ', (tag asString ) ].
	
	^ ErlangPid tag: tag node: node id: id serial: serial creation: creation.
]

{ #category : #converting }
ErlangPidEncoder class >> encode: aPid to: aStream [
	"Write a list of things into a stream"
	| tag |
	
	tag := aPid tag.
	
	aStream nextPut: tag.
	self encodeTerm: (aPid node) to: aStream.
	aStream nextPutAll: (aPid id asByteArrayOfSize: 4).
	aStream nextPutAll: (aPid serial asByteArrayOfSize: 4).
	
	tag = PidTag ifTrue: [ aStream nextPut: (aPid creation ). ^ self ].
	tag = NewPidTag ifTrue: [ aStream nextPutAll: ((aPid creation) asByteArrayOfSize: 4). ^ self ].
	Error signal: 'Unknown pid tag: ', (tag asString).
]

{ #category : #initialization }
ErlangPidEncoder class >> initialize [
	"comment stating purpose of message"

	PidTag := 103.
	NewPidTag := 88.
	
	EncodersDict at: NewPidTag put: self.
	EncodersDict at: PidTag put: self.
]
