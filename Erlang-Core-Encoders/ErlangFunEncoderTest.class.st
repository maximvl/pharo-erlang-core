"
An ErlangFunEncoderTest is a test class for testing the behavior of ErlangFunEncoder
"
Class {
	#name : #ErlangFunEncoderTest,
	#superclass : #TestCase,
	#category : #'Erlang-Core-Encoders-Tests'
}

{ #category : #tests }
ErlangFunEncoderTest >> testDecode [
	"comment stating purpose of message"
	
	| node pid ref module fun1 vars1 fun2 vars2 fun3 |
	node := #'nonode@nohost'.
	module := #shell.
	pid := ErlangPid tag: 103 node: node id: 134 serial: 0 creation: 0.
	ref := ErlangRef tag: 114 node: node ids: #(109535 2880307201 2336466245) creation: 0.
	
	fun1 := ErlangFun pid: pid module: module index: 5 oldIndex: 5 uniq: 98304428 freeVars: { pid } arity: 2 md5: #[187 128 53 144 134 52 31 81 99 175 208 84 132 182 44 254].
	
	vars1 := { { #value . fun1 } . ref . pid }.
	
	fun2 := ErlangFun pid: pid module: module index: 12 oldIndex: 12 uniq: 983004428 freeVars: vars1 arity: 1 md5: #[187 128 53 144 134 52 31 81 99 175 208 84 132 182 44 254].
	
	vars2 := { { #value . fun1 } . ref . fun2 . pid }.
	
	fun3 := ErlangFun pid: pid module: module index: 21 oldIndex: 21 uniq: 98304428 freeVars: vars2 arity: 3 md5: #[187 128 53 144 134 52 31 81 99 175 208 84 132 182 44 254].
	
	" this one comes from "
	" F = fun(X) -> X end."
	" term_to_binary(F)."

	self 
		assert: ( ErlangTermEncoder fromByteArray: #[112 0 0 2 212 1 189 144 182 154 187 236 207 96 89 18 34 161 52 152 16 
  216 0 0 0 6 0 0 0 1 100 0 8 101 114 108 95 101 118 97 108 97 6 98 5 236 133 
  180 103 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 
  134 0 0 0 0 0 104 4 106 104 2 100 0 4 101 118 97 108 112 0 0 1 215 3 187 128 
  53 144 134 52 31 81 99 175 208 84 132 182 44 254 0 0 0 21 0 0 0 4 100 0 5 
  115 104 101 108 108 97 21 98 5 220 1 172 103 100 0 13 110 111 110 111 100 
  101 64 110 111 104 111 115 116 0 0 0 134 0 0 0 0 0 104 2 100 0 5 118 97 108 
  117 101 112 0 0 0 96 2 187 128 53 144 134 52 31 81 99 175 208 84 132 182 44 
  254 0 0 0 5 0 0 0 1 100 0 5 115 104 101 108 108 97 5 98 5 220 1 172 103 100 
  0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 134 0 0 0 0 0 
  103 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 60 0 0 
  0 0 0 114 0 3 100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 
  0 1 171 223 171 174 0 1 139 67 165 69 112 0 0 0 235 1 187 128 53 144 134 52 
  31 81 99 175 208 84 132 182 44 254 0 0 0 12 0 0 0 3 100 0 5 115 104 101 108 
  108 97 12 98 5 220 1 172 103 100 0 13 110 111 110 111 100 101 64 110 111 104 
  111 115 116 0 0 0 134 0 0 0 0 0 104 2 100 0 5 118 97 108 117 101 112 0 0 0 
  96 2 187 128 53 144 134 52 31 81 99 175 208 84 132 182 44 254 0 0 0 5 0 0 0 
  1 100 0 5 115 104 101 108 108 97 5 98 5 220 1 172 103 100 0 13 110 111 110 
  111 100 101 64 110 111 104 111 115 116 0 0 0 134 0 0 0 0 0 103 100 0 13 110 
  111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 60 0 0 0 0 0 114 0 3 
  100 0 13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 1 171 223 
  171 174 0 1 139 67 165 69 103 100 0 13 110 111 110 111 100 101 64 110 111 
  104 111 115 116 0 0 0 60 0 0 0 0 0 103 100 0 13 110 111 110 111 100 101 64 
  110 111 104 111 115 116 0 0 0 60 0 0 0 0 0 104 2 100 0 5 118 97 108 117 101 
  112 0 0 0 96 2 187 128 53 144 134 52 31 81 99 175 208 84 132 182 44 254 0 0 
  0 5 0 0 0 1 100 0 5 115 104 101 108 108 97 5 98 5 220 1 172 103 100 0 13 110 
  111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 134 0 0 0 0 0 103 100 0 
  13 110 111 110 111 100 101 64 110 111 104 111 115 116 0 0 0 60 0 0 0 0 0 108 
  0 0 0 1 104 5 100 0 6 99 108 97 117 115 101 97 1 108 0 0 0 1 104 3 100 0 3 
  118 97 114 97 1 100 0 1 88 106 106 108 0 0 0 1 104 3 100 0 3 118 97 114 97 1 
  100 0 1 88 106 106])
		equals: (ErlangFun pid: (ErlangPid tag: 103 node: #'nonode@nohost' id: 134 serial: 0 creation: 0)
								module: #erl_eval index: 6 oldIndex: 6 uniq: 99386804
								freeVars: {{ (#() asOrderedCollection) . 
												{ #eval . fun3 } .
												{ #value . fun1 } . 
												({ { { #clause . 1 . ({ { #var . 1 . #X}} asOrderedCollection) . ({} asOrderedCollection) . ({{#var . 1 . #X}} asOrderedCollection )} } } asOrderedCollection)  }} 
								arity: 1 
								md5: #[189 144 182 154 187 236 207 96 89 18 34 161 52 152 16 216] ).
							
						
					
				
]
