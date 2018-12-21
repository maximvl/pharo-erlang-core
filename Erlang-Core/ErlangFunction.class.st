"
Erlang function object
"
Class {
	#name : #ErlangFunction,
	#superclass : #Object,
	#instVars : [
		'pid',
		'module',
		'index',
		'old_index',
		'uniq',
		'freeVars',
		'arity',
		'md5'
	],
	#category : #'Erlang-Core'
}

{ #category : #converting }
ErlangFunction >> asErlangObject: aStream [
	"comment stating purpose of message"

	^ 'a funny fun'.
]
