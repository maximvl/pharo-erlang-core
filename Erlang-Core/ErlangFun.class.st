"
Erlang function object
"
Class {
	#name : #ErlangFun,
	#superclass : #Object,
	#instVars : [
		'pid',
		'module',
		'index',
		'oldIndex',
		'uniq',
		'freeVars',
		'arity',
		'md5'
	],
	#category : #'Erlang-Core'
}

{ #category : #accessing }
ErlangFun >> = another [
	"comment stating purpose of message"

	^ self class = (another class) and: 
		[self arity = (another arity) and: 
		[self module = (another module) and:
		[self md5 = (another md5) and:
		[self uniq = (another uniq)]]]].
]

{ #category : #accessing }
ErlangFun >> arity [
	"comment stating purpose of message"

	^ arity.
]

{ #category : #accessing }
ErlangFun >> arity: aValue [
	"comment stating purpose of message"

	arity := aValue
]

{ #category : #converting }
ErlangFun >> asString [
	"comment stating purpose of message"

	^ '#Fun<', module, '.', (oldIndex asString), '.', (uniq asString), '>'.
]

{ #category : #'*Erlang-core' }
ErlangFun >> erlangEncoder [
	"comment stating purpose of message"

	^ #ErlangFunEncoder.
]

{ #category : #accessing }
ErlangFun >> freeVars [
	"comment stating purpose of message"

	^ freeVars 
]

{ #category : #accessing }
ErlangFun >> freeVars: aValue [
	"comment stating purpose of message"

	freeVars := aValue
]

{ #category : #accessing }
ErlangFun >> hash [
	"comment stating purpose of message"
	(arity hash) bitXor: 
	((module hash) bitXor:
	((md5 hash) bitXor: 
	((uniq hash)))).
]

{ #category : #accessing }
ErlangFun >> index [
	"comment stating purpose of message"

	^ index
]

{ #category : #accessing }
ErlangFun >> index: aValue [
	"comment stating purpose of message"

	index := aValue
]

{ #category : #accessing }
ErlangFun >> md5 [
	"comment stating purpose of message"

	^ md5
]

{ #category : #accessing }
ErlangFun >> md5: aValue [
	"comment stating purpose of message"

	md5 := aValue
]

{ #category : #accessing }
ErlangFun >> module [
	"comment stating purpose of message"

	^ module
]

{ #category : #accessing }
ErlangFun >> module: aValue [
	"comment stating purpose of message"

	module := aValue
]

{ #category : #accessing }
ErlangFun >> oldIndex [
	"comment stating purpose of message"

	^ oldIndex
]

{ #category : #accessing }
ErlangFun >> oldIndex: aValue [
	"comment stating purpose of message"

	oldIndex := aValue
]

{ #category : #accessing }
ErlangFun >> pid [
	"comment stating purpose of message"

	^ pid
]

{ #category : #accessing }
ErlangFun >> pid: aValue [
	"comment stating purpose of message"

	pid := aValue
]

{ #category : #accessing }
ErlangFun >> uniq [
	"comment stating purpose of message"

	^ uniq
]

{ #category : #accessing }
ErlangFun >> uniq: aValue [
	"comment stating purpose of message"

	uniq := aValue
]
