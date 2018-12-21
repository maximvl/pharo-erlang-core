"
Erlang Port object
"
Class {
	#name : #ErlangPort,
	#superclass : #Object,
	#instVars : [
		'tag',
		'id',
		'creation',
		'node'
	],
	#category : #'Erlang-Core'
}

{ #category : #initialization }
ErlangPort class >> tag: aTag node: aNode id: anId creation: aCreation [
	"Initialize an object"

	^ (self new)
		tag: aTag;
		node: aNode;
		id: anId;
		creation: aCreation.
]

{ #category : #comparing }
ErlangPort >> = another [
	"comment stating purpose of message"

	^ self class = (another class) and: 
		[self id = (another id) and: 
		[self node = (another node) and:
		[self creation = (another creation) and:
		[self tag = (another tag)]]]].
]

{ #category : #'*Erlang-Core' }
ErlangPort >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writePort: self to: aStream.
]

{ #category : #convertion }
ErlangPort >> asString [
	"comment stating purpose of message"

	^ '#Port<', node, '.', id, '>'
]

{ #category : #accessing }
ErlangPort >> creation [
	"comment stating purpose of message"

	^ creation
]

{ #category : #private }
ErlangPort >> creation: aCreation [
	"comment stating purpose of message"

	creation := aCreation .
]

{ #category : #comparing }
ErlangPort >> hash [
	"comment stating purpose of message"
	(id hash) bitXor: 
	((node hash) bitXor:
	((tag hash) bitXor:  
	((creation hash)))).
]

{ #category : #accessing }
ErlangPort >> id [
	"comment stating purpose of message"

	^ id
]

{ #category : #private }
ErlangPort >> id: anId [
	"comment stating purpose of message"

	id := anId
]

{ #category : #accessing }
ErlangPort >> node [
	"comment stating purpose of message"

	^ node
]

{ #category : #private }
ErlangPort >> node: aNode [
	"comment stating purpose of message"

	node := aNode
]

{ #category : #accessing }
ErlangPort >> tag [
	"comment stating purpose of message"

	^ tag
]

{ #category : #private }
ErlangPort >> tag: aTag [
	"comment stating purpose of message"

	tag := aTag
]
