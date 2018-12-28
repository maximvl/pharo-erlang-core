"
An ErlangFloatEncoderTest is a test class for testing the behavior of ErlangFloatEncoder
"
Class {
	#name : #ErlangFloatEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangFloatEncoderTest >> testDecode [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[70 63 254 102 102 102 102 102 102])
		equals: 1.9.
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[70 64 150 151 254 221 5 41 53])
		equals: 1445.99889.
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[70 189 168 48 115 17 159 33 216])
		equals: -0.000000000011.
]

{ #category : #tests }
ErlangFloatEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: 1.9 )
		equals: #[70 63 254 102 102 102 102 102 102].
		
	self
		assert: (ErlangTermEncoder asByteArray: 1445.99889)
		equals: #[70 64 150 151 254 221 5 41 53].
		
	self
		assert: (ErlangTermEncoder asByteArray: -0.000000000011)
		equals: #[70 189 168 48 115 17 159 33 216].
]
