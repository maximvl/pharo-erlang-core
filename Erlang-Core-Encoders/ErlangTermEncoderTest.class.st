"
An ErlangTermEncoderTest is a test class for testing the behavior of ErlangTermEncoder
"
Class {
	#name : #ErlangTermEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangTermEncoderTest >> testBooleans [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: true)
		equals: #[119 4 116 114 117 101].
	
	self
		assert: (ErlangTermEncoder fromByteArray: #[119 4 116 114 117 101])
		equals: true.
		
	self
		assert: (ErlangTermEncoder asByteArray: false)
		equals: #[119 5 102 97 108 115 101].
	
	self
		assert: (ErlangTermEncoder fromByteArray: #[119 5 102 97 108 115 101])
		equals: false.
		
	self
		assert: (ErlangTermEncoder asByteArray: false)
		equals: (ErlangTermEncoder asByteArray: #false).
		
	self
		assert: (ErlangTermEncoder asByteArray: true)
		equals: (ErlangTermEncoder asByteArray: #true).
]

{ #category : #tests }
ErlangTermEncoderTest >> testCharacters [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: $a)
		equals: #[97 97].
	
	self
		assert: (ErlangTermEncoder fromByteArray: #[97 97])
		equals: ($a asInteger).
		
	self
		assert: (ErlangTermEncoder asByteArray: $щ)
		equals: #[98 0 0 4 73].
	
	self
		assert: (ErlangTermEncoder fromByteArray: #[98 0 0 4 73])
		equals: ($щ asInteger ).
		
	self
		assert: (ErlangTermEncoder asByteArray: $a)
		equals: (ErlangTermEncoder asByteArray: ($a asInteger)).
		
	self
		assert: (ErlangTermEncoder asByteArray: $щ)
		equals: (ErlangTermEncoder asByteArray: ($щ asInteger)).
]
