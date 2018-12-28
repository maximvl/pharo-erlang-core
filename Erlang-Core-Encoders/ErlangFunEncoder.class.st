"
Encode Erlang functions
"
Class {
	#name : #ErlangFunEncoder,
	#superclass : #ErlangTermEncoder,
	#classVars : [
		'FunTag',
		'NewFunTag'
	],
	#category : #'Erlang-Core-Encoders'
}

{ #category : #converting }
ErlangFunEncoder class >> decode: aStream [
	"comment stating purpose of message"

	| arity tag nFreeVars pid module index uniq freeVars md5 oldIndex |
	
	tag := aStream next.
	tag = FunTag
		ifTrue: [ 
			nFreeVars := (aStream next: 4) asInteger .
			pid := self decodeTerm: aStream.
			module := self decodeTerm: aStream.
			index := self decodeTerm: aStream.
			uniq := self decodeTerm: aStream.
			freeVars := (1 to: nFreeVars) collect: [ :n | self decodeTerm: aStream ].
			^ ErlangFun pid: pid module: module index: index uniq: uniq freeVars: freeVars arity: arity md5: md5 ]
		ifFalse: [
			aStream next: 4.
			arity := aStream next.
			md5 := aStream next: 16.
			index := (aStream next: 4) asInteger.
			nFreeVars := (aStream next: 4) asInteger.
			module := self decodeTerm: aStream.
			oldIndex := self decodeTerm: aStream.
			uniq := self decodeTerm: aStream.
			pid := self decodeTerm: aStream.
			freeVars := (1 to: nFreeVars) collect: [ :n | self decodeTerm: aStream ].
			^ ErlangFun pid: pid module: module index: index oldIndex: oldIndex uniq: uniq freeVars: freeVars arity: arity md5: md5 ].
	
]

{ #category : #converting }
ErlangFunEncoder class >> encode: aFun to: aStream [
	"comment stating purpose of message"

	| arity vars bytes size |
	arity := aFun arity.
	vars := aFun freeVars.
	arity = -1 
		ifTrue: [ 
			aStream nextPut: FunTag .
			aStream nextPutAll: ((vars size) asByteArrayOfSize: 4).
			self encodeTerm: (aFun pid) to: aStream.
			self encodeTerm: (aFun module) to: aStream.
			self encodeTerm: (aFun index) to: aStream.
			self encodeTerm: (aFun uniq) to: aStream.
			vars do: [ :v | self encodeTerm: v to: aStream ] ]
		ifFalse: [ 
			aStream nextPut: NewFunTag .
		
			" Stream into a temporary array to get the size before writing into the real one "	
			bytes := ByteArray streamContents: [ :s |
				s nextPut: arity.
				s nextPutAll: (aFun md5).
				s nextPutAll: (aFun index asByteArrayOfSize: 4).
				s nextPutAll: (vars size asByteArrayOfSize: 4).
				self encodeTerm: (aFun module) to: s.
				self encodeTerm: (aFun old_index) to: s.
				self encodeTerm: (aFun uniq) to: s.
				self encodeTerm: (aFun pid) to: s.
				vars do: [ :v | self encodeTerm: v to: s ] ].
		
			size := bytes size.
			aStream nextPutAll: ((size + 4) asByteArrayOfSize: 4).	
			aStream nextPutAll: bytes ]
			
]

{ #category : #initialization }
ErlangFunEncoder class >> initialize [
	"comment stating purpose of message"

	FunTag := 117.
	NewFunTag := 112.
	
	EncodersDict at: FunTag put: self.
	EncodersDict at: NewFunTag put: self.
]
