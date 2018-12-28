"
Encodes Erlang Refs
"
Class {
	#name : #ErlangRefEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'NewRefTag',
		'NewerRefTag',
		'RefTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangRefEncoder class >> decode: aStream [
	| tag ids size node creation |
	
	tag := aStream next.
	size := (aStream next: 2) asInteger .
	node := self decodeTerm: aStream.
	tag = NewRefTag 
		ifTrue: [
			creation := aStream next. ]
		ifFalse: [ 
			creation := (aStream next: 4) asInteger ].

	ids := (1 to: size) collect: [ :e | (aStream next: 4) asInteger ].
	^ ErlangRef tag: tag node: node ids: ids creation: creation.
]

{ #category : #converting }
ErlangRefEncoder class >> encode: aRef to: aStream [
	"Write a list of things into a stream"
	| tag ids size |
	
	tag := aRef tag.
	ids := aRef ids.
	size := ids size.
	
	aStream nextPut: tag.
	aStream nextPutAll: (size asByteArrayOfSize: 2).
	self encodeTerm: (aRef node) to: aStream.
	
	tag = NewRefTag 
		ifTrue: [ 
			aStream nextPut: (aRef creation ). 
			aStream nextPutAll: (((ids at: 1) & 16r3ffff) asByteArrayOfSize: 4) ]
		ifFalse: [ 
			tag = NewerRefTag
				ifTrue: [
					aStream nextPutAll: ((aRef creation) asByteArrayOfSize: 4).
					aStream nextPutAll: ((ids at: 1) asByteArrayOfSize: 4) ]
				ifFalse: [ 
					Error signal: 'Unsupported ref tag: ', (tag asString ) ]	
	 	].
	
	2 to: size do: [ :i | aStream nextPutAll: ((ids at: i) asByteArrayOfSize: 4) ].
]

{ #category : #initialization }
ErlangRefEncoder class >> initialize [
	"comment stating purpose of message"
	
	RefTag := 101.
	NewRefTag := 114.
	NewerRefTag := 90.
	

	EncodersDict at: NewRefTag put: self.
	EncodersDict at: NewerRefTag put: self.
]
