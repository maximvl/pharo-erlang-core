"
Encode Unicode symbols separately
"
Class {
	#name : #ErlangAtomUtfEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'AtomUtf8Tag',
		'MaxAtomLength',
		'SmallAtomUtf8Tag',
		'UTF8Encoder'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangAtomUtfEncoder class >> decode: aStream [
	"Write a string as an atom into a stream"
	| size bytes tag symbol |
	tag := aStream next.
	size := (
		tag = SmallAtomUtf8Tag
			ifTrue: [ aStream next ]
			ifFalse: [ 
				"it has to be AtomUtf8Tag or AtomTag"
				(aStream next: 2) asInteger	] ).
	
	bytes := aStream next: size.
	symbol := (UTF8Encoder decodeBytes: bytes) asSymbol.
	symbol = #true ifTrue: [ ^ true ].
	symbol = #false ifTrue: [ ^ false ].
	^ symbol.
]

{ #category : #converting }
ErlangAtomUtfEncoder class >> encode: aSymbol to: aStream [
	"comment stating purpose of message"

	| size bytes string |
	
	string := aSymbol asString .
	
	size := string size.
	size > MaxAtomLength ifTrue: [ Error signal: 'Symbol exceeds max atom length: ', aSymbol ].
	
	bytes := UTF8Encoder encodeString: string.
	size := bytes size.
	
	size < 256 
		ifTrue: [ 
			aStream nextPut: SmallAtomUtf8Tag.
			aStream nextPut: size.
		]
		ifFalse: [
			aStream nextPut: AtomUtf8Tag.
			aStream nextPutAll: (size asByteArrayOfSize: 2)
		].
	aStream nextPutAll: bytes.
]

{ #category : #initialization }
ErlangAtomUtfEncoder class >> initialize [

	AtomUtf8Tag := 118.
	SmallAtomUtf8Tag := 119.	
	MaxAtomLength := 255.
	UTF8Encoder  := ZnUTF8Encoder new.
	
	EncodersDict at: AtomUtf8Tag put: self.
	EncodersDict at: SmallAtomUtf8Tag put: self.
]
