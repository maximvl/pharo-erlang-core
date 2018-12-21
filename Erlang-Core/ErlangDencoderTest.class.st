"
An ErlangDencoderTest is a test class for testing the behavior of ErlangDencoder
"
Class {
	#name : #ErlangDencoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Tests'
}

{ #category : #tests }
ErlangDencoderTest >> testMaybeListOrString [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[107 0 3 97 98 99])
		equals: 'abc'.
		
	self
		assert: (ErlangDencoder fromByteArray: #[107 0 3 1 4 20])
		equals: #(1 4 20) asOrderedCollection .
		
	self
		assert: (ErlangDencoder fromByteArray: #[108 0 0 0 4 98 0 0 4 66 98 0 0 4 53 98 0 0 4 65 98 0 0 4 66 106])
		equals: 'тест' .
		
	self
		assert: (ErlangDencoder fromByteArray: #[108 0 0 0 3 98 0 0 42 48 98 0 0 4 26 97 255 106])
		equals: #(10800 1050 255) asOrderedCollection  .
]

{ #category : #tests }
ErlangDencoderTest >> testRead32Integer [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[98 255 255 255 246])
		equals: -10.
		
	self
		assert: (ErlangDencoder fromByteArray: #[98 0 1 136 148])
		equals: 100500.
]

{ #category : #tests }
ErlangDencoderTest >> testReadAtom [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[119 4 97 116 111 109])
		equals: #atom.
		
	self
		assert: (ErlangDencoder fromByteArray: #[119 8 208 176 209 130 208 190 208 188])
		equals: #атом.
		
	self
		assert: (ErlangDencoder fromByteArray: #[ 118 1 44 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 ])
		equals: ('ж' repeat: 150) asSymbol .
]

{ #category : #tests }
ErlangDencoderTest >> testReadBigInteger [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[110 6 0 0 0 0 0 0 1])
		equals: (2 raisedTo: 40).
		
	self
		assert: (ErlangDencoder fromByteArray: #[110 6 1 0 0 0 0 0 1]) 
		equals: (2 raisedTo: 40) negated.
		
]

{ #category : #tests }
ErlangDencoderTest >> testReadBiggestInteger [
	"comment stating purpose of message"

	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangDencoder fromByteArray: #[111 0 0 1 14 0 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 139 231 166 65 99 90 129 115 166 108 201 137 5 139 222 223 164 
  164 69 162 140 160 187 212 122 73 213 161 163 186 130 82 234 246 39 227 217 
  156 105 98 38 45 203 216 91 25 99 133 138 43 59 202 87 18 121 119 4 38 215 
  171 86 72 124 243 96 100 236 45 75 105 242 30 133 2 48 217 201 192 47 23 210 
  30 173 245 175 236 117 146 223 117 244 247 23 145 164 39 178 0 126 52 184 98 
  222 91 49 156 187 26 236 198 219 39 37 165 139 133 146 96 20 246 251 94 67 
  106 67 230 73 194 156 0 46 82 139 208 206 173 118 35 107 192 1 143 154 213 
  115 107 71 229 142 125 8 220 129 196 200 55 50 148 139 197 200 28 57 165 69 
  15 166 197 43 213 216 52 162 187 52 28 205 254 89 191 195 2 64 136 168 37 
  146 243 16])
		equals: ('1' repeat: 650) asInteger.
]

{ #category : #tests }
ErlangDencoderTest >> testReadBoolean [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[119 5 102 97 108 115 101])
		equals: false.
		
	self
		assert: (ErlangDencoder fromByteArray: #[119 4 116 114 117 101])
		equals: true.
		
	"non-utf style encoding"
		
	self
		assert: (ErlangDencoder fromByteArray: #[100 0 5 102 97 108 115 101])
		equals: false.
		
	self
		assert: (ErlangDencoder fromByteArray: #[100 0 4 116 114 117 101])
		equals: true.
		
]

{ #category : #tests }
ErlangDencoderTest >> testReadInteger [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[97 10])
		equals: 10.
		
	self
		assert: (ErlangDencoder fromByteArray: #[98 255 255 255 246])
		equals: -10.
		
	self
		assert: (ErlangDencoder fromByteArray: #[97 0])
		equals: 0.
		
	self
		assert: (ErlangDencoder fromByteArray: #[98 0 1 136 148])
		equals: 100500.
		
	self
		assert: (ErlangDencoder fromByteArray: #[110 6 0 0 0 0 0 0 1])
		equals: (2 raisedTo: 40).
		
	self
		assert: (ErlangDencoder fromByteArray: #[110 6 1 0 0 0 0 0 1]) 
		equals: (2 raisedTo: 40) negated.
		
	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangDencoder fromByteArray: #[111 0 0 1 14 0 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 139 231 166 65 99 90 129 115 166 108 201 137 5 139 222 223 164 
  164 69 162 140 160 187 212 122 73 213 161 163 186 130 82 234 246 39 227 217 
  156 105 98 38 45 203 216 91 25 99 133 138 43 59 202 87 18 121 119 4 38 215 
  171 86 72 124 243 96 100 236 45 75 105 242 30 133 2 48 217 201 192 47 23 210 
  30 173 245 175 236 117 146 223 117 244 247 23 145 164 39 178 0 126 52 184 98 
  222 91 49 156 187 26 236 198 219 39 37 165 139 133 146 96 20 246 251 94 67 
  106 67 230 73 194 156 0 46 82 139 208 206 173 118 35 107 192 1 143 154 213 
  115 107 71 229 142 125 8 220 129 196 200 55 50 148 139 197 200 28 57 165 69 
  15 166 197 43 213 216 52 162 187 52 28 205 254 89 191 195 2 64 136 168 37 
  146 243 16])
		equals: ('1' repeat: 650) asInteger.
]

{ #category : #tests }
ErlangDencoderTest >> testReadList [
	"Test decoding of lists"

	self
		assert: (ErlangDencoder fromByteArray: #[108 0 0 0 3 97 1 97 2 97 3 106])
		equals: {1 . 2 . 3} asOrderedCollection.
		
	self
		assert: (ErlangDencoder fromByteArray: #[106] )
		equals: {} asOrderedCollection .
		
	self
		assert: (ErlangDencoder fromByteArray: #[108 0 0 0 3 97 1 119 4 116 114 117 101 106 106] )
		equals: {1 . true . ({} asOrderedCollection )} asOrderedCollection.
]

{ #category : #tests }
ErlangDencoderTest >> testReadPid [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[103 100 0 13 110 111 110 111 100 101 64 110 111 104 
  															 111 115 116 0 0 0 65 0 0 0 0 0])
		equals: (ErlangPid tag: 103 node: #'nonode@nohost' id: 65 serial: 0 creation: 0 ).
]

{ #category : #tests }
ErlangDencoderTest >> testReadPort [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[102 100 0 13 110 111 110 111 100 101 64 110 111 104 
  															 111 115 116 0 0 2 16 0])
		equals: (ErlangPort tag: 102 node: #'nonode@nohost' id: 528 creation: 0 ).
]

{ #category : #tests }
ErlangDencoderTest >> testReadRef [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[114 0 3 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 
  															 2 149 212 251 148 0 3 88 23 172 76])
		equals: (ErlangRef tag: 114 node: #'nonode@nohost' ids: { 169428 . 4220780547 . 1477946444 } creation: 0 ).
]

{ #category : #tests }
ErlangDencoderTest >> testReadSmallInteger [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[97 10])
		equals: 10.
		
	self
		assert: (ErlangDencoder fromByteArray: #[97 0])
		equals: 0.

]

{ #category : #tests }
ErlangDencoderTest >> testReadString [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder fromByteArray: #[107 0 4 116 101 115 116])
		equals: 'test'.
		
	self
		assert: (ErlangDencoder fromByteArray: #[107 0 11 65 98 99 115 59 44 46 115 45 47 64])
		equals: 'Abcs;,.s-/@'.
	self
		assert: (ErlangDencoder fromByteArray: #[108 0 0 0 6 98 0 0 4 65 98 0 0 4 66 98 0 0 4 64 98 0 0 4 62 98 0 0 4 58 98 0 0 4 48 106])
		equals: 'строка'.
]

{ #category : #tests }
ErlangDencoderTest >> testReadTuple [
	"comment stating purpose of message"

	| test_bytes |
	
	self
		assert: (ErlangDencoder fromByteArray: #[104 3 97 1 97 2 97 3])
		equals: #(1 2 3).
		
	self
		assert: (ErlangDencoder fromByteArray: #[104 0] )
		equals: #().
		
	test_bytes := ByteArray streamContents: [ :s | 300 timesRepeat: [ s nextPut: 97; nextPut: 17 ] ].
	
	self
		assert: (ErlangDencoder fromByteArray: (#[105 0 0 1 44] , test_bytes))
		equals: (Array new: 300 withAll: 17).
]

{ #category : #tests }
ErlangDencoderTest >> testWrite32IntegerTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: -10)
		equals: #[98 255 255 255 246].
		
	self
		assert: (ErlangDencoder asByteArray: 100500)
		equals: #[98 0 1 136 148].
		
]

{ #category : #tests }
ErlangDencoderTest >> testWriteAtomTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: #atom)
		equals: #[119 4 97 116 111 109].
		
	self
		assert: (ErlangDencoder asByteArray: #атом)
		equals: #[119 8 208 176 209 130 208 190 208 188].
		
	self
		assert: (ErlangDencoder asByteArray: (('ж' repeat: 150) asSymbol))
		equals: #[ 118 1 44 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 
  182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 
  208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 208 182 ].
]

{ #category : #tests }
ErlangDencoderTest >> testWriteBigIntegerTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: (2 raisedTo: 40))
		equals: #[110 6 0 0 0 0 0 0 1].
		
	self
		assert: (ErlangDencoder asByteArray: ((2 raisedTo: 40) negated))
		equals: #[110 6 1 0 0 0 0 0 1].
		
	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangDencoder asByteArray: (('1' repeat: 650) asInteger))
		equals: #[111 0 0 1 14 0 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 139 231 166 65 99 90 129 115 166 108 201 137 5 139 222 223 164 
  164 69 162 140 160 187 212 122 73 213 161 163 186 130 82 234 246 39 227 217 
  156 105 98 38 45 203 216 91 25 99 133 138 43 59 202 87 18 121 119 4 38 215 
  171 86 72 124 243 96 100 236 45 75 105 242 30 133 2 48 217 201 192 47 23 210 
  30 173 245 175 236 117 146 223 117 244 247 23 145 164 39 178 0 126 52 184 98 
  222 91 49 156 187 26 236 198 219 39 37 165 139 133 146 96 20 246 251 94 67 
  106 67 230 73 194 156 0 46 82 139 208 206 173 118 35 107 192 1 143 154 213 
  115 107 71 229 142 125 8 220 129 196 200 55 50 148 139 197 200 28 57 165 69 
  15 166 197 43 213 216 52 162 187 52 28 205 254 89 191 195 2 64 136 168 37 
  146 243 16].
]

{ #category : #tests }
ErlangDencoderTest >> testWriteBooleanTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: false)
		equals: #[119 5 102 97 108 115 101].
		
	self
		assert: (ErlangDencoder asByteArray: true)
		equals: #[119 4 116 114 117 101].
		
]

{ #category : #tests }
ErlangDencoderTest >> testWriteCharacterTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: $a)
		equals: #[97 97].

	self
		assert: (ErlangDencoder asByteArray: $я)
		equals: #[98 0 0 4 79].

]

{ #category : #tests }
ErlangDencoderTest >> testWriteIntegerTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: 10)
		equals: #[97 10].
		
	self
		assert: (ErlangDencoder asByteArray: -10)
		equals: #[98 255 255 255 246].
		
	self
		assert: (ErlangDencoder asByteArray: 0)
		equals: #[97 0].
		
	self
		assert: (ErlangDencoder asByteArray: 100500)
		equals: #[98 0 1 136 148].
		
	self
		assert: (ErlangDencoder asByteArray: (2 raisedTo: 40))
		equals: #[110 6 0 0 0 0 0 0 1].
		
	self
		assert: (ErlangDencoder asByteArray: ((2 raisedTo: 40) negated))
		equals: #[110 6 1 0 0 0 0 0 1].
		
	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangDencoder asByteArray: (('1' repeat: 650) asInteger))
		equals: #[111 0 0 1 14 0 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
  199 113 28 139 231 166 65 99 90 129 115 166 108 201 137 5 139 222 223 164 
  164 69 162 140 160 187 212 122 73 213 161 163 186 130 82 234 246 39 227 217 
  156 105 98 38 45 203 216 91 25 99 133 138 43 59 202 87 18 121 119 4 38 215 
  171 86 72 124 243 96 100 236 45 75 105 242 30 133 2 48 217 201 192 47 23 210 
  30 173 245 175 236 117 146 223 117 244 247 23 145 164 39 178 0 126 52 184 98 
  222 91 49 156 187 26 236 198 219 39 37 165 139 133 146 96 20 246 251 94 67 
  106 67 230 73 194 156 0 46 82 139 208 206 173 118 35 107 192 1 143 154 213 
  115 107 71 229 142 125 8 220 129 196 200 55 50 148 139 197 200 28 57 165 69 
  15 166 197 43 213 216 52 162 187 52 28 205 254 89 191 195 2 64 136 168 37 
  146 243 16].
]

{ #category : #tests }
ErlangDencoderTest >> testWriteListTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: {1 . 2 . 3} asOrderedCollection )
		equals: #[108 0 0 0 3 97 1 97 2 97 3 106].
		
	self
		assert: (ErlangDencoder asByteArray: {} asOrderedCollection )
		equals: #[106].
		
	self
		assert: (ErlangDencoder asByteArray: {1 . true . ({} asOrderedCollection )} asOrderedCollection )
		equals: #[108 0 0 0 3 97 1 119 4 116 114 117 101 106 106].
]

{ #category : #tests }
ErlangDencoderTest >> testWriteSmallIntegerTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: 10)
		equals: #[97 10].
		
	self
		assert: (ErlangDencoder asByteArray: 0)
		equals: #[97 0].
]

{ #category : #tests }
ErlangDencoderTest >> testWriteStringTo [
	"comment stating purpose of message"

	self
		assert: (ErlangDencoder asByteArray: '')
		equals: #[106].

	self
		assert: (ErlangDencoder asByteArray: 'test')
		equals: #[107 0 4 116 101 115 116].
		
	self
		assert: (ErlangDencoder asByteArray: 'Abcs;,.s-/@')
		equals: #[107 0 11 65 98 99 115 59 44 46 115 45 47 64].
		
	self
		assert: (ErlangDencoder asByteArray: 'строка')
		equals: #[108 0 0 0 6 98 0 0 4 65 98 0 0 4 66 98 0 0 4 64 98 0 0 4 62 98 0 0 4 58 98 0 0 4 48 106].
]

{ #category : #tests }
ErlangDencoderTest >> testWriteTupleTo [
	"comment stating purpose of message"

	| test_bytes |
	self
		assert: (ErlangDencoder asByteArray: { 1 . 2 . 3 } )
		equals: #[104 3 97 1 97 2 97 3].
		
	self
		assert: (ErlangDencoder asByteArray: { } )
		equals: #[104 0].
		
	test_bytes := ByteArray streamContents: [ :s | 300 timesRepeat: [ s nextPut: 97; nextPut: 17 ] ].
	
	self
		assert: (ErlangDencoder asByteArray: (Array new: 300 withAll: 17 ))
		equals: #[105 0 0 1 44] , test_bytes .
]
