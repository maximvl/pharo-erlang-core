"
An ErlangIntegerEncoderTest is a test class for testing the behavior of ErlangIntegerEncoder
"
Class {
	#name : #ErlangIntegerEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangIntegerEncoderTest >> testDecode [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[97 10])
		equals: 10 .
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[98 255 255 255 246])
		equals: -10 .

	self
		assert: (ErlangTermEncoder fromByteArray: #[110 6 0 0 0 0 0 0 1] )
		equals: (2 raisedTo: 40).
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[110 6 1 0 0 0 0 0 1])
		equals: ((2 raisedTo: 40) negated).
		
	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangTermEncoder fromByteArray: #[111 0 0 1 14 0 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
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
  146 243 16] )
		equals: (('1' repeat: 650) asInteger).
]

{ #category : #tests }
ErlangIntegerEncoderTest >> testDecode32Integer [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[98 255 255 255 246])
		equals: -10.
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[98 0 1 136 148])
		equals: 100500.
]

{ #category : #tests }
ErlangIntegerEncoderTest >> testDecodeBigInteger [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[110 6 0 0 0 0 0 0 1])
		equals: (2 raisedTo: 40).
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[110 6 1 0 0 0 0 0 1]) 
		equals: (2 raisedTo: 40) negated.
]

{ #category : #tests }
ErlangIntegerEncoderTest >> testDecodeBiggestInteger [
	"comment stating purpose of message"

	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangTermEncoder fromByteArray: #[111 0 0 1 14 0 199 113 28 199 113 28 199 113 28 199 113 28 199 113 28 
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
ErlangIntegerEncoderTest >> testDecodeSmallInteger [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder fromByteArray: #[97 10])
		equals: 10.
		
	self
		assert: (ErlangTermEncoder fromByteArray: #[97 0])
		equals: 0.
]

{ #category : #tests }
ErlangIntegerEncoderTest >> testEncode32IntegerTo [
	"comment stating purpose of message"
	
	self
		assert: (ErlangTermEncoder asByteArray: -10)
		equals: #[98 255 255 255 246].
		
	self
		assert: (ErlangTermEncoder asByteArray: 100500)
		equals: #[98 0 1 136 148].
]

{ #category : #tests }
ErlangIntegerEncoderTest >> testEncodeBigIntegerTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: (2 raisedTo: 40))
		equals: #[110 6 0 0 0 0 0 0 1].
		
	self
		assert: (ErlangTermEncoder asByteArray: ((2 raisedTo: 40) negated))
		equals: #[110 6 1 0 0 0 0 0 1].
		
	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangTermEncoder asByteArray: (('1' repeat: 650) asInteger))
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
ErlangIntegerEncoderTest >> testEncodeSmallIntegerTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: 10)
		equals: #[97 10].
		
	self
		assert: (ErlangTermEncoder asByteArray: 0)
		equals: #[97 0].
]

{ #category : #tests }
ErlangIntegerEncoderTest >> testEncodeTo [
	"comment stating purpose of message"

	self
		assert: (ErlangTermEncoder asByteArray: 10)
		equals: #[97 10].
		
	self
		assert: (ErlangTermEncoder asByteArray: -10)
		equals: #[98 255 255 255 246].

	self
		assert: (ErlangTermEncoder asByteArray: (2 raisedTo: 40))
		equals: #[110 6 0 0 0 0 0 0 1].
		
	self
		assert: (ErlangTermEncoder asByteArray: ((2 raisedTo: 40) negated))
		equals: #[110 6 1 0 0 0 0 0 1].
		
	" erlang code for this one: 
		> {Z, _} = string:to_integer(string:copies("1", 650)).
		> term_to_binary(Z).
	".
	
	self 
		assert: (ErlangTermEncoder asByteArray: (('1' repeat: 650) asInteger))
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
