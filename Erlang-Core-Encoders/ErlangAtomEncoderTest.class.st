"
An ErlangAtomEncoderTest is a test class for testing the behavior of ErlangAtomEncoder
"
Class {
	#name : #ErlangAtomEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangAtomEncoderTest >> testDecode [
	"comment stating purpose of message"

	| encoded stream |

	stream := ReadStream on: #[100 0 4 97 116 111 109].
	
	self
		assert: (ErlangAtomEncoder decode: stream)
		equals: #atom.
]

{ #category : #tests }
ErlangAtomEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	| encoded |
	
	encoded := ByteArray streamContents: [ :s | ErlangAtomEncoder encode: #atom to: s ].

	self
		assert: encoded
		equals: #[100 0 4 97 116 111 109].
]
