"
Erlang reference object
"
Class {
	#name : #ErlangRef,
	#superclass : #Object,
	#instVars : [
		'tag',
		'ids',
		'creation',
		'node'
	],
	#category : #'Erlang-Core'
}

{ #category : #'as yet unclassified' }
ErlangRef class >> tag: aTag node: aNode ids: anIds creation: aCreation [
	"Initialize an object"

	^ (self new)
		tag: aTag;
		node: aNode;
		ids: anIds;
		creation: aCreation.
]

{ #category : #comparing }
ErlangRef >> = another [
	"comment stating purpose of message"

	^ self class = (another class) and: 
		[self ids = (another ids) and: 
		[self node = (another node) and:
		[self creation = (another creation) and:
		[self tag = (another tag)]]]].
]

{ #category : #converting }
ErlangRef >> asString [
	"comment stating purpose of message"
	^ '#Ref<', node, '.', ('.' join: (ids reversed)), '>'
]

{ #category : #accessing }
ErlangRef >> creation [
	"comment stating purpose of message"

	^ creation.
]

{ #category : #private }
ErlangRef >> creation: arg [
	"comment stating purpose of message"

	creation := arg.
]

{ #category : #'*Erlang-Core' }
ErlangRef >> erlangEncoder [
	"comment stating purpose of message"

	^ #ErlangRefEncoder.
]

{ #category : #comparing }
ErlangRef >> hash [
	"comment stating purpose of message"
	(ids hash) bitXor: 
	((node hash) bitXor:
	((tag hash) bitXor:  
	((creation hash)))).
]

{ #category : #accessing }
ErlangRef >> ids [
	"comment stating purpose of message"

	^ ids.
]

{ #category : #private }
ErlangRef >> ids: arg [
	"comment stating purpose of message"

	ids := arg.
]

{ #category : #accessing }
ErlangRef >> node [
	"comment stating purpose of message"

	^ node.
]

{ #category : #private }
ErlangRef >> node: arg [
	"comment stating purpose of message"

	node := arg.
]

{ #category : #accessing }
ErlangRef >> tag [
	"comment stating purpose of message"

	^ tag.
]

{ #category : #private }
ErlangRef >> tag: arg [
	"comment stating purpose of message"

	tag := arg.
]
