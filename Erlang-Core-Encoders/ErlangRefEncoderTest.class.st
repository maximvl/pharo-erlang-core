"
An ErlangRefEncoderTest is a test class for testing the behavior of ErlangRefEncoder
"
Class {
	#name : #ErlangRefEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangRefEncoderTest >> testDecode [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[114 0 3 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 
  															 2 149 212 251 148 0 3 88 23 172 76])
		equals: (ErlangRef tag: 114 node: #'nonode@nohost' ids: { 169428 . 4220780547 . 1477946444 } creation: 0 ).
]

{ #category : #tests }
ErlangRefEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: (ErlangRef tag: 114 node: #'nonode@nohost' ids: { 169428 . 4220780547 . 1477946444 } creation: 0 ))
		"equals: #[114 0 3 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 2 149 212 251 148 0 3 88 23 172 76]"
		equals: #[114 0 3 119 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 2 149 212 251 148 0 3 88 23 172 76].
]
