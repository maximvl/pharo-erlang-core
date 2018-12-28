"
An ErlangPortEncoderTest is a test class for testing the behavior of ErlangPortEncoder
"
Class {
	#name : #ErlangPortEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangPortEncoderTest >> testDecode [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[102 100 0 13 110 111 110 111 100 101 64 110 111 104 
  															 111 115 116 0 0 2 16 0])
		equals: (ErlangPort tag: 102 node: #'nonode@nohost' id: 528 creation: 0 ).
]

{ #category : #tests }
ErlangPortEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: (ErlangPort tag: 102 node: #'nonode@nohost' id: 528 creation: 0 ))
		"equals: #[102 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 2 16 0]."
		equals: #[102 119 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 2 16 0].
]
