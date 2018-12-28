"
Encodes Erlang atoms
"
Class {
	#name : #ErlangAtomEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'AtomTag',
		'MaxAtomLength',
		'SmallAtomTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangAtomEncoder class >> decode: aStream [
	"comment stating purpose of message"
	
	| size bytes tag symbol |
	tag := aStream next.
	size := (
		tag = SmallAtomTag
			ifTrue: [ aStream next ]
			ifFalse: [ (aStream next: 2) asInteger ]). 
	bytes := aStream next: size.
	symbol := bytes asString asSymbol.
	symbol = #true ifTrue: [ ^ true ].
	symbol = #false ifTrue: [ ^ false ].
	^ symbol.

]

{ #category : #converting }
ErlangAtomEncoder class >> encode: aSymbol to: aStream [
	"comment stating purpose of message"

	| size bytes |
	
	size := aSymbol size.
	size > MaxAtomLength ifTrue: [ Error signal: 'Symbol exceeds max atom length: ', aSymbol ].
	
	bytes := aSymbol asByteArray .
	size := bytes size.
	
	aStream nextPut: AtomTag .
	aStream nextPutAll: (size asByteArrayOfSize: 2).	
	aStream nextPutAll: bytes.
]

{ #category : #initialization }
ErlangAtomEncoder class >> initialize [
	"comment stating purpose of message"
	
	AtomTag := 100.
	SmallAtomTag := 115.
	
	MaxAtomLength := 255.
	
	EncodersDict at: AtomTag put: self.
]
