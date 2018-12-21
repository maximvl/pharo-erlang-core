"
A helper class to encode/decode Erlang terms
"
Class {
	#name : #ErlangDencoder,
	#superclass : #Object,
	#classVars : [
		'AtomTag',
		'AtomTags',
		'AtomUtf8Tag',
		'BinTag',
		'BitBinTag',
		'CompressedTag',
		'ErlMax',
		'ErlMin',
		'ExternalFunTag',
		'FloatTag',
		'FunTag',
		'HashABC',
		'HashConst',
		'IntTag',
		'IntegerTags',
		'LargeBigTag',
		'LargeTupleTag',
		'ListTag',
		'ListTags',
		'MapTag',
		'Max32Integer',
		'MaxAtomLength',
		'MaxStringLength',
		'Min32Integer',
		'NewFloatTag',
		'NewFunTag',
		'NewPidTag',
		'NewPortTag',
		'NewRefTag',
		'NewerRefTag',
		'NilTag',
		'PidTag',
		'PidTags',
		'PortTag',
		'PortTags',
		'RefTag',
		'RefTags',
		'SmallAtomUtf8Tag',
		'SmallBigTag',
		'SmallIntTag',
		'SmallTupleTag',
		'StringTag',
		'TupleTags',
		'UTF8Encoder',
		'VersionTag'
	],
	#category : #'Erlang-Core'
}

{ #category : #converting }
ErlangDencoder class >> asByteArray: anObject [
	^ ByteArray streamContents: [ :s | anObject asErlangObject: s ].
]

{ #category : #converting }
ErlangDencoder class >> fromByteArray: someBytes [
	^ self readObject: (ReadStream on: someBytes) .
]

{ #category : #initialization }
ErlangDencoder class >> initialize [
	"Initialize all Erlang constants"
	
	UTF8Encoder  := ZnUTF8Encoder new.
	
	Min32Integer := (2 raisedTo: 31) negated.
	Max32Integer := (2 raisedTo: 31) - 1.
	
	MaxAtomLength := 255.
	MaxStringLength := 65535.

	SmallIntTag := 97.
	IntTag := 98.
	FloatTag := 99.
	NewFloatTag := 70.
	AtomTag := 100.
	RefTag := 101.
	PortTag := 102.
	NewPortTag := 89.
	PidTag := 103.
	NewPidTag := 88.
	SmallTupleTag := 104.
	LargeTupleTag := 105.
	NilTag := 106.
	StringTag := 107.
	ListTag := 108.
	BinTag := 109.
	BitBinTag := 77.
	SmallBigTag := 110.
	LargeBigTag := 111.
	NewFunTag := 112.
	ExternalFunTag := 113.
	NewRefTag := 114.
	NewerRefTag := 90.
	MapTag := 116.
	FunTag := 117.
	AtomUtf8Tag := 118.
	SmallAtomUtf8Tag := 119.
	CompressedTag := 80.
	VersionTag := 131.
	
	IntegerTags := { SmallIntTag . IntTag . SmallBigTag . LargeBigTag }.
	AtomTags := { SmallAtomUtf8Tag . AtomUtf8Tag . AtomTag }.
	ListTags := { ListTag . NilTag }.
	TupleTags := { SmallTupleTag . LargeTupleTag }.
	PidTags := { PidTag . NewPidTag }.
	PortTags := { PortTag . NewPortTag }.
	RefTags := { RefTag . NewRefTag . NewerRefTag  }.
	
	ErlMax := (1 << 27) - 1.
	ErlMin := (1 << 27) negated.
	
	

]

{ #category : #converting }
ErlangDencoder class >> maybeListOrString: aList [
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

{ #category : #reading }
ErlangDencoder class >> read32Integer: aStream [
	"comment stating purpose of message"
	| bytes negative |
	bytes := aStream next: 4.
	negative := ((bytes at: 1) bitAt: 8) isZero not. 
	negative ifTrue: [ ^ (#(255 255 255 256) - bytes) asByteArray asInteger negated ]
	ifFalse: [ ^ bytes asInteger  ].
]

{ #category : #reading }
ErlangDencoder class >> readAtom: aStream [
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

{ #category : #reading }
ErlangDencoder class >> readBigInteger: aStream [
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

{ #category : #reading }
ErlangDencoder class >> readBiggestInteger: aStream [
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

{ #category : #reading }
ErlangDencoder class >> readInteger: aStream [
	"comment stating purpose of message"

	| tag |
	tag := aStream next.
	(tag = SmallIntTag) ifTrue: [ ^ self readSmallInteger: aStream ].
	(tag = IntTag) ifTrue: [ ^ self read32Integer: aStream ].
	(tag = SmallBigTag) ifTrue: [ ^ self readBigInteger: aStream ].
	(tag = LargeBigTag) ifTrue: [ ^ self readBiggestInteger: aStream ].
	Error signal: ('Not a integer tag: ', tag asString).
]

{ #category : #reading }
ErlangDencoder class >> readList: aStream [
	"Reads a list of objects from a stream"
	| tag size list |
	
	tag := aStream next.
	tag = NilTag ifTrue: [ ^ OrderedCollection new ].
	
	size := (aStream next: 4) asInteger.
	list := (1 to: size) collect: [ :n | self readObject: aStream ] as: OrderedCollection .
	tag := aStream next.
	tag = NilTag ifFalse: [ Error signal: 'List doesnt end with a NilTag' ].
	
	^ self maybeListOrString: list.
]

{ #category : #reading }
ErlangDencoder class >> readObject: aStream [
	"comment stating purpose of message"
	| tag |
	tag := aStream peek.
	(IntegerTags includes: tag) ifTrue: [ ^ self readInteger: aStream  ].
	(AtomTags includes: tag) ifTrue: [  ^ self readAtom: aStream ].
	(ListTags includes: tag) ifTrue: [ ^ self readList: aStream ].
	(TupleTags includes: tag) ifTrue: [ ^ self readTuple: aStream ]. 
	tag = StringTag ifTrue: [ ^ self readString: aStream ].
	(PidTags includes: tag) ifTrue: [ ^ self readPid: aStream ].
	(PortTags includes: tag) ifTrue: [ ^ self readPort: aStream ].
	(RefTags includes: tag) ifTrue: [ ^ self readRef: aStream ].
	Error signal: 'Unsupported tag: ', (tag asString).
]

{ #category : #reading }
ErlangDencoder class >> readPid: aStream [
	"Write a list of things into a stream"
	| tag node creation serial id |
	
	tag := aStream next.
	node := self readAtom: aStream.
	id := (aStream next: 4) asInteger .
	serial := (aStream next: 4) asInteger .
	
	tag = PidTag ifTrue: [ creation := aStream next . ].
	tag = NewPidTag ifTrue: [ creation := (aStream next: 4) asInteger ].
	creation ifNil: [ Error signal: 'Unsupported pid tag: ', (tag asString ) ].
	
	^ ErlangPid tag: tag node: node id: id serial: serial creation: creation.
]

{ #category : #reading }
ErlangDencoder class >> readPort: aStream [
	"Write a list of things into a stream"
	| tag node id creation |
	
	tag := aStream next.
	node := self readAtom: aStream.
	id := (aStream next: 4) asInteger .
	tag = PortTag ifTrue: [ creation := aStream next  ].
	tag = NewPortTag ifTrue: [ creation := (aStream next: 4) asInteger ].
	creation ifNil: [ Error signal: 'Unknown port tag: ', (tag asString ) ].
	
	^ ErlangPort tag: tag node: node id: id creation: creation .
		
]

{ #category : #reading }
ErlangDencoder class >> readRef: aStream [
	"Write a list of things into a stream"
	| tag ids size node creation |
	
	tag := aStream next.
	size := (aStream next: 2) asInteger .
	node := self readAtom: aStream.
	tag = NewRefTag 
		ifTrue: [
			creation := aStream next. ]
		ifFalse: [ 
			tag = NewerRefTag
				ifTrue: [
					creation := (aStream next: 4) asInteger ]
				ifFalse: [ 
					Error signal: 'Unsupported port tag: ', (tag asString ) ]	
	 	].

	ids := (1 to: size) collect: [ :e | (aStream next: 4) asInteger ].
	^ ErlangRef tag: tag node: node ids: ids creation: creation.
]

{ #category : #reading }
ErlangDencoder class >> readSmallInteger: aStream [
	"comment stating purpose of message"

	^ aStream next.
]

{ #category : #reading }
ErlangDencoder class >> readString: aStream [
	"Reads a string from a stream"
	| size bytes |
	aStream next.
	size := (aStream next: 2) asInteger.
	bytes := aStream next: size.
	^ self maybeListOrString: bytes.
]

{ #category : #reading }
ErlangDencoder class >> readTuple: aStream [
	"Write a list of things into a stream"
	| tag size |
	
	tag := aStream next.
	size := (tag = SmallTupleTag 
					ifTrue: [ aStream next ]
					ifFalse: [ (aStream next: 4) asInteger ]).
	
	^ (1 to: size) collect: [ :n | self readObject: aStream  ].
]

{ #category : #writing }
ErlangDencoder class >> write32Integer: anInt to: aStream [
	"comment stating purpose of message"

	aStream nextPut: IntTag .
	anInt negative 
		ifTrue: [ aStream nextPutAll: (#(255 255 255 256) - (anInt asByteArrayOfSize: 4)) ]  "this is required since asByteArrayOfSize does not handle negative cases"
		ifFalse: [ aStream nextPutAll: (anInt asByteArrayOfSize: 4).	].
]

{ #category : #writing }
ErlangDencoder class >> writeAtom: aString to: aStream [
	"Write a string as an atom into a stream"
	| size bytes |
	size := aString size.
	size > MaxAtomLength ifTrue: [ Error signal: 'String exceeds max atom length: ', aString  ].
	
	bytes := UTF8Encoder encodeString: aString.
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

{ #category : #writing }
ErlangDencoder class >> writeBigInteger: anInt to: aStream [
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

{ #category : #writing }
ErlangDencoder class >> writeInteger: anInt to: aStream [
	"Wrete an integer in a correct format into a stream"
	(anInt between: 0 and: 255) ifTrue: [ ^ self writeSmallInteger: anInt to: aStream ].
	(anInt between: Min32Integer and: Max32Integer) ifTrue: [ ^ self write32Integer: anInt to: aStream ].
	self writeBigInteger: anInt to: aStream.
]

{ #category : #writing }
ErlangDencoder class >> writeList: aList to: aStream [
	"Write a list of things into a stream"
	| size |
	
	size := aList size.
	size isZero ifTrue: [
		aStream nextPut: NilTag . 
		^ self.
	].
	
	aStream nextPut: ListTag .
	aStream nextPutAll: (size asByteArrayOfSize: 4).
	aList do: [ :e | e asErlangObject: aStream  ].
	aStream nextPut: NilTag .
	
]

{ #category : #writing }
ErlangDencoder class >> writePid: aPid to: aStream [
	"Write a list of things into a stream"
	| tag |
	
	tag := aPid tag.
	
	aStream nextPut: tag.
	self writeAtom: (aPid node) to: aStream.
	aStream nextPutAll: (aPid id asByteArrayOfSize: 4).
	aStream nextPutAll: (aPid serial asByteArrayOfSize: 4).
	
	tag = PidTag ifTrue: [ aStream nextPut: (aPid creation ). ^ self ].
	tag = NewPidTag ifTrue: [ aStream nextPutAll: ((aPid creation) asByteArrayOfSize: 4). ^ self ].
	Error signal: 'Unknown pid tag: ', (tag asString).
]

{ #category : #writing }
ErlangDencoder class >> writePort: aPort to: aStream [
	"Write a list of things into a stream"
	| tag |
	
	tag := aPort tag.
	
	aStream nextPut: tag.
	self writeAtom: (aPort node) to: aStream.
	aStream nextPutAll: (aPort id asByteArrayOfSize: 4).
	
	tag = PortTag ifTrue: [ aStream nextPut: (aPort creation ). ^ self ].
	tag = NewPortTag ifTrue: [ aStream nextPutAll: ((aPort creation) asByteArrayOfSize: 4). ^ self ].
	Error signal: 'Unknown port tag: ', (tag asString).
]

{ #category : #writing }
ErlangDencoder class >> writeRef: aRef to: aStream [
	"Write a list of things into a stream"
	| tag ids size |
	
	tag := aRef tag.
	ids := aRef ids.
	size := ids size.
	
	aStream nextPut: tag.
	aStream nextPutAll: (size asByteArrayOfSize: 2).
	self writeAtom: (aRef node) to: aStream.
	
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
					Error signal: 'Unsupported port tag: ', (tag asString ) ]	
	 	].
	
	2 to: size do: [ :i | aStream nextPutAll: ((ids at: i) asByteArrayOfSize: 4) ].
]

{ #category : #writing }
ErlangDencoder class >> writeSmallInteger: anInt to: aStream [
	"comment stating purpose of message"

	aStream nextPut: SmallIntTag .
	aStream nextPut: anInt .
]

{ #category : #writing }
ErlangDencoder class >> writeString: aString to: aStream [
	"Write a string as an atom into a stream"
	| size isASCII |
	size := aString size.
	size isZero ifTrue: [
		aStream nextPut: NilTag . 
		^ self.
	].
	
	isASCII := aString isAsciiString .
	(isASCII and: (size <= MaxStringLength)) ifTrue: [ 
		aStream nextPut: StringTag .
		aStream nextPutAll: (size asByteArrayOfSize: 2).
		aStream nextPutAll: (aString asByteArray).
		^ self.	
	].
	
	aStream nextPut: ListTag .
	aStream nextPutAll: (size asByteArrayOfSize: 4).
	aString do: [ :e | self writeInteger: (e asInteger) to: aStream  ].
	aStream nextPut: NilTag .
	
]

{ #category : #writing }
ErlangDencoder class >> writeTuple: anArray to: aStream [
	"Write a list of things into a stream"
	| size |
	
	size := anArray size.
	size < 255 ifTrue: [ 
		aStream nextPut: SmallTupleTag .
		aStream nextPut: size ]
	 ifFalse: [
		aStream nextPut: LargeTupleTag .
		aStream nextPutAll: (size asByteArrayOfSize: 4) ].
	
	anArray do: [ :e | e asErlangObject: aStream ].
]
