"
Encode Erlang maps as Dictionaries
"
Class {
	#name : #ErlangMapEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'MapTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangMapEncoder class >> decode: aStream [
	"comment stating purpose of message"

	| size pairs |
	
	aStream next.
	size := (aStream next: 4) asInteger .
	pairs := (1 to: size * 2) collect: [ :n | self decodeTerm: aStream ].
	
	^ Dictionary newFromPairs: pairs.
]

{ #category : #converting }
ErlangMapEncoder class >> encode: aMap to: aStream [
	"comment stating purpose of message"

	| size |
	aStream nextPut: MapTag .
	size := aMap size.
	
	aStream nextPutAll: (size asByteArrayOfSize: 4).
	
	aMap associationsDo: [ :pair | 
		self encodeTerm: (pair key) to: aStream.
		self encodeTerm: (pair value) to: aStream ].
]

{ #category : #initialization }
ErlangMapEncoder class >> initialize [
	"comment stating purpose of message"

	MapTag := 116.
	
	EncodersDict at: MapTag put: self.
]
