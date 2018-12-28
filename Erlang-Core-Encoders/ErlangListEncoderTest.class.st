"
An ErlangListEncoderTest is a test class for testing the behavior of ErlangListEncoder
"
Class {
	#name : #ErlangListEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangListEncoderTest >> testDecode [
	"Test decoding of lists"

	self
		assert: (ErlangTermEncoder fromByteArray: #[107 0 3 1 2 3])
		equals: {1 . 2 . 3} asOrderedCollection.
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[106] )
		equals: {} asOrderedCollection .
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[108 0 0 0 3 97 1 119 4 116 114 117 101 106 106] )
		equals: {1 . true . ({} asOrderedCollection )} asOrderedCollection.
]

{ #category : #tests }
ErlangListEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: {1 . 2 . 3} asOrderedCollection )
		equals: #[107 0 3 1 2 3].
		
	self
		assert: (ErlangTermEncoder asByteArray: {} asOrderedCollection )
		equals: #[106].
		
	self
		assert: (ErlangTermEncoder asByteArray: {1 . true . ({} asOrderedCollection )} asOrderedCollection )
		equals: #[108 0 0 0 3 97 1 119 4 116 114 117 101 106 106].
]

{ #category : #tests }
ErlangListEncoderTest >> testMaybeListOrString [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[107 0 3 97 98 99])
		equals: 'abc'.
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[107 0 3 1 4 20])
		equals: #(1 4 20) asOrderedCollection .
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[108 0 0 0 4 98 0 0 4 66 98 0 0 4 53 98 0 0 4 65 98 0 0 4 66 106])
		equals: 'тест' .
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[108 0 0 0 3 98 0 0 42 48 98 0 0 4 26 97 255 106])
		equals: #(10800 1050 255) asOrderedCollection  .
]
