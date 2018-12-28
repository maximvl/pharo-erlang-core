"
Encodes some floats
"
Class {
	#name : #ErlangFloatEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'FloatTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangFloatEncoder class >> decode: aStream [
	"comment stating purpose of message"

	| bytes |
	
	aStream next.
	bytes := aStream next: 8.
	
	^ Float fromIEEE64Bit: (bytes asInteger).
	
]

{ #category : #converting }
ErlangFloatEncoder class >> encode: aFloat to: aStream [
	"comment stating purpose of message"

	| value bytes |
	value := 	((aFloat basicAt: 1) bitShift: 32) + (aFloat basicAt: 2).
	bytes := value asByteArrayOfSize: 8.
	
	aStream nextPut: FloatTag.
	aStream nextPutAll: bytes.
	
]

{ #category : #initialization }
ErlangFloatEncoder class >> initialize [
	"comment stating purpose of message"

	FloatTag := 70.
	
	EncodersDict at: FloatTag  put: self.
]
