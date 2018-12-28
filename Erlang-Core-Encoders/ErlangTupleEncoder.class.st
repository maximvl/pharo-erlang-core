"
Encode Erlang tuples
"
Class {
	#name : #ErlangTupleEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'LargeTupleTag',
		'SmallTupleTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangTupleEncoder class >> decode: aStream [
	"Write a list of things into a stream"
	| tag size |
	
	tag := aStream next.
	size := (tag = SmallTupleTag 
					ifTrue: [ aStream next ]
					ifFalse: [ (aStream next: 4) asInteger ]).
	
	^ (1 to: size) collect: [ :n | self decodeTerm: aStream  ].
]

{ #category : #converting }
ErlangTupleEncoder class >> encode: anArray to: aStream [
	"Write a tuple of things into a stream"
	| size |
	
	size := anArray size.
	size < 255 ifTrue: [ 
		aStream nextPut: SmallTupleTag .
		aStream nextPut: size ]
	 ifFalse: [
		aStream nextPut: LargeTupleTag .
		aStream nextPutAll: (size asByteArrayOfSize: 4) ].
	
	anArray do: [ :e | self encodeTerm: e to: aStream ].
]

{ #category : #initialization }
ErlangTupleEncoder class >> initialize [
	"comment stating purpose of message"
	
	SmallTupleTag := 104.
	LargeTupleTag := 105.
	
	EncodersDict at: SmallTupleTag put: self.
	EncodersDict at: LargeTupleTag put: self.
]
