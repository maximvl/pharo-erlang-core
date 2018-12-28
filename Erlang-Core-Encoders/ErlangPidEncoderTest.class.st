"
An ErlangPidEncoderTest is a test class for testing the behavior of ErlangPidEncoder
"
Class {
	#name : #ErlangPidEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangPidEncoderTest >> testDecode [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[103 100 0 13 110 111 110 111 100 101 64 110 111 104 
  															 111 115 116 0 0 0 65 0 0 0 0 0])
		equals: (ErlangPid tag: 103 node: #'nonode@nohost' id: 65 serial: 0 creation: 0 ).
]

{ #category : #tests }
ErlangPidEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: (ErlangPid tag: 103 node: #'nonode@nohost' id: 65 serial: 0 creation: 0 ))
		"equals: #[103 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 65 0 0 0 0 0]."
		equals: #[103 119 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 65 0 0 0 0 0] .
]
