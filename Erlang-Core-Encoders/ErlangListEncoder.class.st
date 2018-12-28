"
Encode Erlang lists
"
Class {
	#name : #ErlangListEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'ListTag',
		'MaxStringLength',
		'NilTag',
		'StringTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangListEncoder class >> decode: aStream [
	"Reads a list of objects from a stream"
	| tag size list |
	
	tag := aStream next.
	tag = NilTag ifTrue: [ ^ OrderedCollection new ].
	
	tag = StringTag
		ifTrue: [  
			size := (aStream next: 2) asInteger.
			list := (1 to: size) collect: [ :n | aStream next ] as: OrderedCollection .	]
		ifFalse: [ 
			size := (aStream next: 4) asInteger.
			list := (1 to: size) collect: [ :n | self decodeTerm: aStream ] as: OrderedCollection .
			tag := aStream next.
			tag = NilTag ifFalse: [ Error signal: 'List doesnt end with a NilTag' ] ].
	
	^ self maybeListOrString: list.
]

{ #category : #converting }
ErlangListEncoder class >> encode: aList to: aStream [

	"Write a list of things into a stream"
	| size |
	
	size := aList size.
	size isZero ifTrue: [
		aStream nextPut: NilTag . 
		^ self.
	].

	(aList allSatisfy: [ :e | (e isInteger) and: [e between: 0 and: 255] ]) ifTrue: [ 
		aStream nextPut: StringTag .
		aStream nextPutAll: (size asByteArrayOfSize: 2).
		aList do: [ :e | aStream nextPut: e ].
		^ self	 ].
	
	aStream nextPut: ListTag .
	aStream nextPutAll: (size asByteArrayOfSize: 4).
	aList do: [ :e | self encodeTerm: e to: aStream  ].
	aStream nextPut: NilTag .
]

{ #category : #initialization }
ErlangListEncoder class >> initialize [
	"comment stating purpose of message"

	MaxStringLength := 65535.
	
	NilTag := 106.
	StringTag := 107.
	ListTag := 108.
	
	EncodersDict at: NilTag put: self.
	EncodersDict at: StringTag put: self.
	EncodersDict at: ListTag put: self.
]

{ #category : #converting }
ErlangListEncoder class >> maybeListOrString: aList [
	"Reads a list of objects from a stream"
	| string |
	(aList allSatisfy: [ :e | e isInteger ]) 
		ifTrue: [
			string := aList collect: [ :e | e asCharacter ] as: String.
			(string allSatisfy: 
				[ :e | (e isAlphaNumeric) or: 
						 ((e isSeparator) or:
						 ((e isSpecial) or:
						 ((e asInteger) between: 33 and: 175))) ])
				  ifTrue: [ ^ string ].
		].
	^ aList asOrderedCollection .
]
