Class {
	#name : #ErlangDistributionConnection,
	#superclass : #Object,
	#instVars : [
		'status',
		'socket',
		'stream',
		'nodeName',
		'remotePort',
		'cookie'
	],
	#classVars : [
		'Connected',
		'Disconnected'
	],
	#category : #'Erlang-Distribution'
}

{ #category : #'as yet unclassified' }
ErlangDistributionConnection class >> connectTo: aNode [
	"comment stating purpose of message"

	| remotePort connection |
	remotePort := EPMDClient doPortPlease2Req: aNode.
	remotePort ifNil: [ ^ nil ].
	
	connection := self new.
	^ connection connectTo: aNode port: remotePort cookie: self getCookie  .
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection class >> getCookie [
	
	^ '/home/maxim/.erlang.cookie' asFileReference contents.
]

{ #category : #'initialize-release' }
ErlangDistributionConnection >> connectTo: aNode port: aPort cookie: aCookie [
	"comment stating purpose of message"

	| connectionStatus challenge respDigest theirDigest myDigest |
	
	remotePort := aPort.
	cookie := aCookie.
	socket := Socket newTCP .
	socket connectTo: (NetNameResolver addressForName: 'localhost') port: remotePort .
	
	stream := SocketStream on: socket.
	stream binary.
	
	self sendName.
	connectionStatus := self recvStatus .
	connectionStatus ifFalse: [ socket closeAndDestroy . ^ nil ].
	
	challenge := self recvChallenge .
	respDigest := self genDigest: challenge. 
	myDigest := self sendChallengeReply: respDigest.
	
	theirDigest := self recvChallengeAck .
	theirDigest = myDigest ifFalse: [ socket closeAndDestroy . ^ nil ].
	^ self.
]

{ #category : #accessing }
ErlangDistributionConnection >> cookie: aCookie [
	
	cookie := aCookie .
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> genChallenge [

	"
	A challenge is a 32-bit integer in big-endian order. Below the function gen_challenge() returns a random 32-bit integer used as a challenge.
	"
	
	| max |
	max := #[255 255 255 255] asInteger .
	^ max atRandom .
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> genDigest: challenge [

	"
	A digest is a (16 bytes) MD5 hash of the challenge (as text) concatenated with the cookie (as text). Below, the function gen_digest(Challenge, Cookie) generates a digest as described above.
	"
	
	^ MD5 new hashMessage: (cookie, challenge asString ). 
	
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> genDigest: challenge withCookie: cookie [

	"
	A digest is a (16 bytes) MD5 hash of the challenge (as text) concatenated with the cookie (as text). Below, the function gen_digest(Challenge, Cookie) generates a digest as described above.
	"
	
	MD5 new hashMessage: (challenge asString , cookie ). 
	
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> recvChallenge [
	"comment stating purpose of message"
	
	"
	+---+--------+--------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-...-+-----+
	|'n'|Version0|Version1|Flag0|Flag1|Flag2|Flag3|Chal0|Chal1|Chal2|Chal3|Name0|Name1| ... |NameN|
	+---+--------+--------+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-... +-----+
	"
	
	| tag msgSize version flag challenge |
	
	msgSize := (stream next: 2) asInteger.
	tag := stream next.
	version := stream next: 2.
	flag := stream next: 4.
	challenge := stream next: 4.
	stream skip: (msgSize - 1 - 2 - 4 - 4).
	^ challenge asInteger .
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> recvChallengeAck [
	
	"
	B checks that the digest received from A is correct and generates a digest from the challenge received from A. The 	digest is then sent to A. The message is as follows:

	+---+-----+-----+-----+-----+-...-+------+
	|'a'|Dige0|Dige1|Dige2|Dige3| ... |Dige15|
	+---+-----+-----+-----+-----+-...-+------+
	'a' is the tag. 'Dige0' ... 'Dige15' is the digest calculated by B for A's challenge.
	"
	
	| tag msgSize digest |
	
	msgSize := stream next: 2.
	tag := stream next.
	digest := stream next: 16.
	^ digest.
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> recvStatus [
	"comment stating purpose of message"
	
	"+---+-------+-------+-...-+-------+
	 |'s'|Status0|Status1| ... |StatusN|
	 +---+-------+-------+-...-+-------+"
	
	| tag msgSize connectionStatus |
	
	msgSize := (stream next: 2) asInteger .
	tag := stream next.
	connectionStatus := (stream next: (msgSize - 1)) asString .
	connectionStatus = 'ok' ifTrue: [ ^ true ].
	connectionStatus = 'ok_simultaneous' ifTrue: [ ^ true ].
	connectionStatus = 'alive' ifTrue: [ 
		stream nextPutAll: (5 asByteArrayOfSize: 2).	
		stream nextPut: tag.
		stream nextPutAllFlush: 'true' asByteArray
	 ].
	^ false.
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> sendChallengeReply: digest [
	"comment stating purpose of message"
	
	"
	Now A has generated a digest and its own challenge. Those are sent together in a package to B:

	+---+-----+-----+-----+-----+-----+-----+-----+-----+-...-+------+
	|'r'|Chal0|Chal1|Chal2|Chal3|Dige0|Dige1|Dige2|Dige3| ... |Dige15|
	+---+-----+-----+-----+-----+-----+-----+-----+-----+-...-+------+
	'r' is the tag. 'Chal0' ... 'Chal3' is A's challenge for B to handle. 'Dige0' ... 'Dige15' is the digest that A constructed from the challenge B sent in the previous step.
	"
	
	| tag challenge message myDigest |
	
	tag := $r asInteger .
	challenge := self genChallenge .
	myDigest := self genDigest: challenge .
	
	message := ByteArray streamContents: [ :s |
		s nextPut: tag.
		s nextPutAll: (challenge asByteArrayOfSize: 4).
		s nextPutAll: digest
	 ].

	stream nextPutAll: (message size asByteArrayOfSize: 2).
	stream nextPutAllFlush: message.
	^ myDigest 
]

{ #category : #'as yet unclassified' }
ErlangDistributionConnection >> sendName [
	"comment stating purpose of message"
	
	"+---+--------+--------+-----+-----+-----+-----+-----+-----+-...-+-----+"
   "|'n'|Version0|Version1|Flag0|Flag1|Flag2|Flag3|Name0|Name1| ... |NameN|"
   "+---+--------+--------+-----+-----+-----+-----+-----+-----+-... +-----+"

	| message version flags tag |
	
	tag := $n asInteger .
	version := 5.
	flags := #[00 16rdf 16r7f 16rbd].
	
	message := ByteArray streamContents: [ :s |
		s nextPut: tag.
		s nextPutAll: (version asByteArrayOfSize: 2).
		s nextPutAll: flags.
		s nextPutAll: (EPMDClient instance nodeName) asUTF8Bytes .
	 ].
	
	stream nextPutAll: (message size asByteArrayOfSize: 2).
	stream nextPutAllFlush: message asByteArray.
]
