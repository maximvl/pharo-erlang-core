"
Base encoder class to encode/decode arbitrary Erlang objects
"
Class {
	#name : #ErlangTermEncoder,
	#superclass : #Object,
	#classVars : [
		'EncodersDict'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #adding }
ErlangTermEncoder class >> addEncoder: aClass for: aTag [
	"comment stating purpose of message"

	EncodersDict at: aTag put: aClass .
]

{ #category : #converting }
ErlangTermEncoder class >> asByteArray: aTerm [
	"comment stating purpose of message"

	^ ByteArray streamContents: [ :s | self encodeTerm: aTerm to: s ].
]

{ #category : #converting }
ErlangTermEncoder class >> decodeTerm: aStream [
	"reads an object from a stream"

	| tag encoder |
	tag := aStream peek.
	encoder := EncodersDict at: tag ifAbsent: [ Error signal: 'Tag is not supported: ', (tag asString) ].
	^ encoder decode: aStream.
	
]

{ #category : #converting }
ErlangTermEncoder class >> encodeTerm: aTerm to: aStream [
	"Writes an object as Erlang object"

	| encoder term |
	
	term := aTerm.
	(term class canUnderstand: #asErlangTerm) ifTrue: [ 
		term := term asErlangTerm.
	].

	(term class canUnderstand: #erlangEncoder)
		ifTrue: [
			encoder := (term erlangEncoder) asClass.
			encoder encode: term to: aStream.	]
		ifFalse: [ 
			Error signal: 'Dont know how to encode object: ', (term asString) ]
]

{ #category : #converting }
ErlangTermEncoder class >> fromByteArray: someBytes [
	"comment stating purpose of message"

	^ self decodeTerm: (ReadStream on: someBytes )
]

{ #category : #initialization }
ErlangTermEncoder class >> initialize [

	EncodersDict := IdentityDictionary new.
]
