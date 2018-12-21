"
Erlang Process ID
"
Class {
	#name : #ErlangPid,
	#superclass : #Object,
	#instVars : [
		'tag',
		'id',
		'serial',
		'creation',
		'node'
	],
	#category : #'Erlang-Core'
}

{ #category : #initialization }
ErlangPid class >> tag: aTag node: aNode id: anId serial: aSerial creation: aCreation [
	"Initialize an object"

	^ (self new)
		tag: aTag;
		node: aNode;
		id: anId;
		serial: aSerial;
		creation: aCreation.
]

{ #category : #comparing }
ErlangPid >> = another [
	"comment stating purpose of message"

	^ self class = (another class) and: 
		[self id = (another id) and: 
		[self node = (another node) and:
		[self creation = (another creation) and:
		[self serial = (another serial) and:
		[self tag = (another tag)]]]]].
]

{ #category : #'*Erlang-Core' }
ErlangPid >> asErlangObject: aStream [
	"comment stating purpose of message"

	ErlangDencoder writePid: self to: aStream.
]

{ #category : #converting }
ErlangPid >> asString [
	"comment stating purpose of message"

	^ '#Pid<', node, '.', id, '.', serial, '>' 
]

{ #category : #accessing }
ErlangPid >> creation [
	"comment stating purpose of message"

	^ creation.
]

{ #category : #private }
ErlangPid >> creation: aCreation [
	"comment stating purpose of message"

	creation := aCreation.
]

{ #category : #comparing }
ErlangPid >> hash [
	"comment stating purpose of message"
	(id hash) bitXor: 
	((node hash) bitXor:
	((tag hash) bitXor: 
	((serial hash) bitXor: 
	((creation hash))))). 
]

{ #category : #accessing }
ErlangPid >> id [
	"comment stating purpose of message"

	^ id
]

{ #category : #private }
ErlangPid >> id: anId [
	"comment stating purpose of message"

	id := anId.
]

{ #category : #accessing }
ErlangPid >> node [
	"comment stating purpose of message"

	^ node.
]

{ #category : #private }
ErlangPid >> node: aNode [
	"comment stating purpose of message"

	node := aNode.
]

{ #category : #accessing }
ErlangPid >> serial [
	"comment stating purpose of message"

	^ serial.
]

{ #category : #private }
ErlangPid >> serial: aSerial [
	"comment stating purpose of message"

	serial := aSerial.
]

{ #category : #accessing }
ErlangPid >> tag [
	"comment stating purpose of message"

	^ tag.
]

{ #category : #private }
ErlangPid >> tag: aTag [
	"comment stating purpose of message"

	tag := aTag.
]
