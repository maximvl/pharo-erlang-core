"
This class can encode and decode integers in Erlang format
"
Class {
	#name : #ErlangIntegerEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'IntTag',
		'LargeBigTag',
		'Max32Integer',
		'Min32Integer',
		'SmallBigTag',
		'SmallIntTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangIntegerEncoder class >> decode32Integer: aStream [
	"comment stating purpose of message"
	| bytes negative |
	bytes := aStream next: 4.
	negative := ((bytes at: 1) bitAt: 8) isZero not. 
	negative ifTrue: [ ^ (#(255 255 255 256) - bytes) asByteArray asInteger negated ]
	ifFalse: [ ^ bytes asInteger  ].
]

{ #category : #converting }
ErlangIntegerEncoder class >> decode: aStream [
	"comment stating purpose of message"

	| tag |
	tag := aStream next.
	(tag = SmallIntTag) ifTrue: [ ^ self decodeSmallInteger: aStream ].
	(tag = IntTag) ifTrue: [ ^ self decode32Integer: aStream ].
	(tag = SmallBigTag) ifTrue: [ ^ self decodeBigInteger: aStream ].
	(tag = LargeBigTag) ifTrue: [ ^ self decodeBiggestInteger: aStream ].
	Error signal: ('Not a integer tag: ', tag asString).
]

{ #category : #converting }
ErlangIntegerEncoder class >> decodeBigInteger: aStream [
	"comment stating purpose of message"
	| size bytes sign value |
	size := aStream next .
	sign := aStream next.
	bytes := aStream next: size.
	value := bytes reversed asInteger .
	(sign isZero)
		ifTrue: [ ^ value ]
		ifFalse: [ ^ value negated ].
]

{ #category : #converting }
ErlangIntegerEncoder class >> decodeBiggestInteger: aStream [
	"comment stating purpose of message"
	| size bytes sign value |
	size := (aStream next: 4) asInteger.
	sign := aStream next.
	bytes := aStream next: size.
	value := bytes reversed asInteger .
	(sign isZero)
		ifTrue: [ ^ value ]
		ifFalse: [ ^ value negated ].
]

{ #category : #converting }
ErlangIntegerEncoder class >> decodeSmallInteger: aStream [
	"comment stating purpose of message"

	^ aStream next.
]

{ #category : #converting }
ErlangIntegerEncoder class >> encode32Integer: anInt to: aStream [
	"comment stating purpose of message"

	aStream nextPut: IntTag .
	anInt negative 
		ifTrue: [ aStream nextPutAll: (#(255 255 255 256) - (anInt asByteArrayOfSize: 4)) ]  "this is required since asByteArrayOfSize does not handle negative cases"
		ifFalse: [ aStream nextPutAll: (anInt asByteArrayOfSize: 4).	].
]

{ #category : #converting }
ErlangIntegerEncoder class >> encode: anInt to: aStream [
	"comment stating purpose of message"

	(anInt between: 0 and: 255) ifTrue: [ ^ self encodeSmallInteger: anInt to: aStream ].
	(anInt between: Min32Integer and: Max32Integer) ifTrue: [ ^ self encode32Integer: anInt to: aStream ].
	self encodeBigInteger: anInt to: aStream.
]

{ #category : #converting }
ErlangIntegerEncoder class >> encodeBigInteger: anInt to: aStream [
	"comment stating purpose of message"
	| bytes size sign |
	bytes := anInt asByteArray reverse.
	size := bytes size.
	sign := (anInt negative) ifTrue: [ 1 ] ifFalse: [ 0 ].
	(size < 256)
		ifTrue: [ 
			aStream nextPut: SmallBigTag .
			aStream nextPut: size.
		 ]
		ifFalse: [
			aStream nextPut: LargeBigTag .
			aStream nextPutAll: (size asByteArrayOfSize: 4).
		 ].
	aStream nextPut: sign.
	aStream nextPutAll: bytes.
]

{ #category : #converting }
ErlangIntegerEncoder class >> encodeSmallInteger: anInt to: aStream [
	"comment stating purpose of message"

	aStream nextPut: SmallIntTag .
	aStream nextPut: anInt .
]

{ #category : #initialization }
ErlangIntegerEncoder class >> initialize [
	"comment stating purpose of message"
		
	SmallIntTag := 97.
	IntTag := 98.
	SmallBigTag := 110.
	LargeBigTag := 111.

	Min32Integer := (2 raisedTo: 31) negated.
	Max32Integer := (2 raisedTo: 31) - 1.
	
	EncodersDict at: SmallIntTag put: self.
	EncodersDict at: IntTag put: self.
	EncodersDict at: SmallBigTag put: self.
	EncodersDict at: LargeBigTag put: self.
]
