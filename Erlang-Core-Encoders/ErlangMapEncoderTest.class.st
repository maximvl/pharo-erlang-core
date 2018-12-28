"
An ErlangMapEncoderTest is a test class for testing the behavior of ErlangMapEncoder
"
Class {
	#name : #ErlangMapEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangMapEncoderTest >> testDecode [

	self
		assert: (ErlangTermEncoder fromByteArray: #[116 0 0 0 2 97 1 97 10 97 2 97 20])
		equals: (Dictionary newFrom: { 1->10 . 2->20 }).
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[116 0 0 0 4 97 1 119 3 97 98 99 97 2 119 4 116 114 117 101 97 3 104 0 97 4 116 0 0 0 1 119 1 97 119 1 98])
		equals: (Dictionary newFrom: { 1->#abc . 2->true . 3->#() . 4-> (Dictionary newFrom: {#a->#b})}).
]

{ #category : #tests }
ErlangMapEncoderTest >> testEncodeTo [

	self
		assert: (ErlangTermEncoder asByteArray: (Dictionary newFrom: { 1->10 . 2->20 }))
		equals: #[116 0 0 0 2 97 1 97 10 97 2 97 20].
		
	self
		assert: (ErlangTermEncoder asByteArray: (Dictionary newFrom: { 1->#abc . 2->true . 3->#() . 4-> (Dictionary newFrom: {#a->#b})}))
		equals: #[116 0 0 0 4 97 1 119 3 97 98 99 97 2 119 4 116 114 117 101 97 3 104 0 97 4 116 0 0 0 1 119 1 97 119 1 98].
]
