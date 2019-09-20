Class {
	#name : #EPMDClient,
	#superclass : #Object,
	#instVars : [
		'epmdSocket',
		'epmdStream',
		'listenSocket',
		'nodeName',
		'state',
		'listenPort'
	],
	#classVars : [
		'Connected',
		'Disconnected',
		'Instance'
	],
	#category : #'Erlang-Distribution'
}

{ #category : #initialization }
EPMDClient class >> doNamesReq [
	"comment stating purpose of message"
	| socket stream result |
	
	socket := Socket newTCP .

	socket connectTo: (NetNameResolver addressForName: 'localhost' ) port: 4369.

	stream := SocketStream on: socket.
	stream nextPutAll: (1 asByteArrayOfSize: 2).
	stream nextPutAllFlush: #[110].

	stream skip: 4.
	result := stream upToEnd.
	
	socket closeAndDestroy.
	^ result.
]

{ #category : #initialization }
EPMDClient class >> doPortPlease2Req: aNode [
	"comment stating purpose of message"
	| socket stream bytes response nodePort nameLen extraLen |
	
	bytes := ByteArray streamContents: [ :s |
		s nextPut: 122.
		s nextPutAll: aNode asUTF8Bytes  .
	].
	
	socket := Socket newTCP .
	socket connectTo: (NetNameResolver addressForName: 'localhost' ) port: 4369.

	stream := SocketStream on: socket.
	stream binary.
	stream nextPutAll: (bytes size asByteArrayOfSize: 2).
	stream nextPutAllFlush: bytes.
	
	response := stream next: 2.
	((response at: 2) = 0) ifTrue: [ 
		nodePort := (stream next: 2) asInteger .
		stream skip: 1.   "type"
		stream skip: 1. "protocol"
		(stream next: 2) asInteger . "high version"
		(stream next: 2) asInteger . "low version"
		nameLen := (stream next: 2) asInteger .
		stream skip: nameLen. "node name"
		extraLen := (stream next: 2) asInteger.
		stream skip: extraLen . "node extra"
		^ nodePort.
	]
	ifFalse: [ ^ nil ].

]

{ #category : #'class initialization' }
EPMDClient class >> initialize [
	"comment stating purpose of message"

	Instance := nil.
	Connected := 1.
	Disconnected := 0.
]

{ #category : #accessing }
EPMDClient class >> instance [
	"comment stating purpose of message"

	Instance ifNil: [ Instance := (self new) ].
	^ Instance.
]

{ #category : #initialization }
EPMDClient >> connect [
	"comment stating purpose of message"
	
	epmdSocket := Socket newTCP .
	listenSocket := Socket newTCP .

	listenSocket listenOn: listenPort backlogSize: 10. 
	
	epmdSocket connectTo: (NetNameResolver addressForName: 'localhost') port: 4369.
	epmdStream := SocketStream on: epmdSocket.
	
	self doAlive2Req ifFalse: [ state := Disconnected. ^ self ].
	state := Connected .
]

{ #category : #initialization }
EPMDClient >> disconnect [
	"comment stating purpose of message"

	state := Disconnected .
	epmdSocket close . 
	
]

{ #category : #initialization }
EPMDClient >> doAlive2Req [
	"comment stating purpose of message"
	| bytes nameBytes response |
	
	nameBytes := nodeName asUTF8Bytes .
	
	bytes := ByteArray streamContents: [ :s |
		s nextPut: 120.
		s nextPutAll: (listenPort asByteArrayOfSize: 2).
		s nextPutAll: #[72 0 0 5 0 5].
		s nextPutAll: (nameBytes size asByteArrayOfSize: 2).
		s nextPutAll: nameBytes .
		s nextPutAll: #[0 0] .
	].

	self epmdSend: bytes.
	
	response := epmdStream next: 4.
	^ (response at: 2) asInteger = 0.
]

{ #category : #initialization }
EPMDClient >> epmdPort [
	^ 4369
]

{ #category : #initialization }
EPMDClient >> epmdSend: bytes [

	epmdStream nextPutAll: (bytes size asByteArrayOfSize: 2).
	epmdStream nextPutAllFlush: bytes .
	epmdStream flush.
]

{ #category : #initialization }
EPMDClient >> initialize [
	"comment stating purpose of message"

	super initialize .
	nodeName := 'pharo@' , (NetNameResolver localHostName).
	listenPort := 4334.

]

{ #category : #initialization }
EPMDClient >> isConnected [
	"comment stating purpose of message"

	^ state = Connected 
]

{ #category : #initialization }
EPMDClient >> nodeName [
	^ nodeName 
]

{ #category : #initialization }
EPMDClient >> nodeName: aName [
	^ nodeName := aName
]

{ #category : #initialization }
EPMDClient >> port [
	^ 4334
]
