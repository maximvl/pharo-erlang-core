"
An ErlangTupleEncoderTest is a test class for testing the behavior of ErlangTupleEncoder
"
Class {
	#name : #ErlangTupleEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangTupleEncoderTest >> testDecode [
	"comment stating purpose of message"

	| test_bytes |
	
	self
		assert: (ErlangTermEncoder fromByteArray: #[104 3 97 1 97 2 97 3])
		equals: #(1 2 3).
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[104 0] )
		equals: #().
		
	test_bytes := ByteArray streamContents: [ :s | 300 timesRepeat: [ s nextPut: 97; nextPut: 17 ] ].
	
	self
		assert: (ErlangTermEncoder fromByteArray: (#[105 0 0 1 44] , test_bytes))
		equals: (Array new: 300 withAll: 17).
]

{ #category : #tests }
ErlangTupleEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	| test_bytes |
	self
		assert: (ErlangTermEncoder asByteArray: { 1 . 2 . 3 } )
		equals: #[104 3 97 1 97 2 97 3].
		
	self
		assert: (ErlangTermEncoder asByteArray: { } )
		equals: #[104 0].
		
	test_bytes := ByteArray streamContents: [ :s | 300 timesRepeat: [ s nextPut: 97; nextPut: 17 ] ].
	
	self
		assert: (ErlangTermEncoder asByteArray: (Array new: 300 withAll: 17 ))
		equals: #[105 0 0 1 44] , test_bytes .
]
