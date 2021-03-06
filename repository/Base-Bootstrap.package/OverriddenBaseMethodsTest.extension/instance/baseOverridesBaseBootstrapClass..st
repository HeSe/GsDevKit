*base-bootstrap
baseOverridesBaseBootstrapClass: known
	self
		addTo: known
		forBehavior: Class
		overrides: {
			#'_sortedClassVarNames' -> '_sortedClassVarNames

"Returns a sorted list of class variable names. "

^ SortedCollection withAll: classVars keys
'.
			"2.4.4.7"
			#'_definitionInContext:' -> '_definitionInContext: aUserProfile

"Returns a description of the receiver using object names taken from the given
 UserProfile."

| result newByteSubclass anArray lfsp
  aConstraint firstElement inv civs |

result := String new.
result addAll: (superClass == nil ifTrue: [''nil''] ifFalse: [superClass name]).

newByteSubclass := false.
lfsp := (Character lf asString) addAll: ''  ''; yourself.

(self isBytes _and: [superClass isBytes not]) ifTrue: [
  result addAll: '' byteSubclass: ''''''; addAll: name; addLast: $''.
  newByteSubclass := true.
]
ifFalse: [
  (self isIndexable _and: [superClass isIndexable not]) ifTrue: [
    result addAll: '' indexableSubclass: ''''''; addAll: name; addLast: $''.
  ]
  ifFalse: [
    result addAll: '' subclass: ''''''; addAll: name; addLast: $''.
  ]
].

" instVarNames: #( <list of strings> ) "

newByteSubclass ifFalse: [
  result addAll: lfsp;
    addAll: ''instVarNames: #('';
    addAll: (self _instVarNamesWithSeparator: (lfsp , ''                 ''));
    add: $).
].

" classVars: #( <list of strings> ) "
result addAll: lfsp; addLast: ''classVars: #(''.
self _sortedClassVarNames do: [:aKey |
  result addLast: $  . 
  (aKey includesValue: $'') 
    ifTrue:[ result addAll: aKey _asSource ]
    ifFalse:[ result addAll: aKey ].
  ].
result addLast: $).

" classInstVars: #( <list of strings> ) "

result addAll: lfsp; addLast: ''classInstVars: #(''.
civs := self class allInstVarNames.
civs removeFrom: 1 to: (self class superClass instSize).
civs do: [:civName |
  result addLast: $  .
  (civName includesValue: $'') 
    ifTrue:[ result addAll: civName _asSource ]
    ifFalse:[ result addAll: civName ].
].
result addLast: $).

" poolDictionaries: #[ <list of dictionary names> ] "

inv := poolDictionaries isKindOf: InvariantArray.
result addAll: lfsp; addAll: ''poolDictionaries: #''.

result add: (inv ifTrue: [ $( ] ifFalse: [ $[ ]).

firstElement := true.
self sharedPools do: [:each |
  firstElement ifFalse: [ result addAll: '', ''].  "separate with commas"
  anArray := aUserProfile dictionaryAndSymbolOf: each.
  anArray == nil
        ifTrue: [ result addAll: '' "(not named)" '' ]
        ifFalse: [ result addAll: (anArray at: 2)].
  firstElement := false.
].

result add: (inv ifTrue: [ $) ] ifFalse: [ $] ]).

" inDictionary: <name of containing dictionary> "

result addAll: lfsp; addAll: ''inDictionary: ''.
anArray := aUserProfile dictionaryAndSymbolOf: self.
anArray == nil ifTrue: [
  result addAll: ''(class not in your dictionaries)''
]
ifFalse: [
  anArray := aUserProfile dictionaryAndSymbolOf: (anArray at: 1).
  anArray == nil ifTrue: [
    result addAll: ''(dictionary not in your dictionaries)''
  ]
  ifFalse: [
    result addAll: (anArray at: 2)
  ]
].

" constraints: #[ <Array of instance-variable-symbol/class-name pairs> ]
    or
  constraints: <class name> 
  constraints are deprecated - only add if they are present.
  Byte subclasses don''t have instVars thus no constraints"

newByteSubclass ifFalse: [
  self _hasConstraints ifTrue: [
    result add: self _definitionOfConstraints.
    ]
  ].

result addAll: lfsp;
  addAll: ''instancesInvariant: '';
  addAll: (self instancesInvariant describe).

newByteSubclass ifFalse: [		"Byte subclasses don''t have instVars so can''t be modifiable"
  result addAll: lfsp;
    addAll: ''isModifiable: ''; addAll: (self isModifiable describe).
].

result add: Character lf.
^result
'.
			"2.4.4"
			#'_definitionInContext:' -> '_definitionInContext: aUserProfile

"Returns a description of the receiver using object names taken from the given
 UserProfile."

| result newByteSubclass anArray lfsp
  aConstraint firstElement inv civs |

result := String new.
result addAll: (superClass == nil ifTrue: [''nil''] ifFalse: [superClass name]).

newByteSubclass := false.
lfsp := (Character lf asString) addAll: ''  ''; yourself.


(self isBytes _and: [superClass isBytes not]) ifTrue: [
  result addAll: '' byteSubclass: ''''''; addAll: name; addLast: $''.
  newByteSubclass := true.
]
ifFalse: [
  (self isIndexable _and: [superClass isIndexable not]) ifTrue: [
    result addAll: '' indexableSubclass: ''''''; addAll: name; addLast: $''.
  ]
  ifFalse: [
    result addAll: '' subclass: ''''''; addAll: name; addLast: $''.
  ]
].

" instVarNames: #( <list of strings> ) "

newByteSubclass ifFalse: [
  result addAll: lfsp;
    addAll: ''instVarNames: #('';
    addAll: (self _instVarNamesWithSeparator: (lfsp , ''                 ''));
    add: $).
].

" classVars: #( <list of strings> ) "
result addAll: lfsp; addLast: ''classVars: #(''.
self _sortedClassVarNames do: [:aKey |
  result addLast: $  . 
  (aKey includesValue: $'') 
    ifTrue:[ result addAll: aKey _asSource ]
    ifFalse:[ result addAll: aKey ].
  ].
result addLast: $).

" classInstVars: #( <list of strings> ) "

result addAll: lfsp; addLast: ''classInstVars: #(''.
civs := self class allInstVarNames.
civs removeFrom: 1 to: (self class superClass instSize).
civs do: [:civName |
  result addLast: $  .
  (civName includesValue: $'') 
    ifTrue:[ result addAll: civName _asSource ]
    ifFalse:[ result addAll: civName ].
].
result addLast: $).

" poolDictionaries: #[ <list of dictionary names> ] "

inv := poolDictionaries isKindOf: InvariantArray.
result addAll: lfsp; addAll: ''poolDictionaries: #''.

result add: (inv ifTrue: [ $( ] ifFalse: [ $[ ]).

firstElement := true.
self sharedPools do: [:each |
  firstElement ifFalse: [ result addAll: '', ''].  "separate with commas"
  anArray := aUserProfile dictionaryAndSymbolOf: each.
  anArray == nil
        ifTrue: [ result addAll: '' "(not named)" '' ]
        ifFalse: [ result addAll: (anArray at: 2)].
  firstElement := false.
].

result add: (inv ifTrue: [ $) ] ifFalse: [ $] ]).

" inDictionary: <name of containing dictionary> "

result addAll: lfsp; addAll: ''inDictionary: ''.
anArray := aUserProfile dictionaryAndSymbolOf: self.
anArray == nil ifTrue: [
  result addAll: ''(class not in your dictionaries)''
]
ifFalse: [
  anArray := aUserProfile dictionaryAndSymbolOf: (anArray at: 1).
  anArray == nil ifTrue: [
    result addAll: ''(dictionary not in your dictionaries)''
  ]
  ifFalse: [
    result addAll: (anArray at: 2)
  ]
].

" contraints: removed because it is a ''Backward Compatibility'' method -- See Bug 40536"

result addAll: lfsp;
  addAll: ''instancesInvariant: '';
  addAll: (self instancesInvariant describe).

newByteSubclass ifFalse: [		"Byte subclasses don''t have instVars so can''t be modifiable"
  result addAll: lfsp;
    addAll: ''isModifiable: ''; addAll: (self isModifiable describe).
].

result add: Character lf.
^result
'.
			"2.3.x"
			#'_definitionInContext:' -> '_definitionInContext: aUserProfile

"Returns a description of the receiver using object names taken from the given
 UserProfile."

| result newByteSubclass anArray lfsp
  aConstraint firstElement inv civs |

result := String new.
result addAll: (superClass == nil ifTrue: [''nil''] ifFalse: [superClass name]).

newByteSubclass := false.
lfsp := (Character lf asString) addAll: ''  ''; yourself.


(self isBytes _and: [superClass isBytes not]) ifTrue: [
  result addAll: '' byteSubclass: ''''''; addAll: name; addLast: $''.
  newByteSubclass := true.
]
ifFalse: [
  (self isIndexable _and: [superClass isIndexable not]) ifTrue: [
    result addAll: '' indexableSubclass: ''''''; addAll: name; addLast: $''.
  ]
  ifFalse: [
    result addAll: '' subclass: ''''''; addAll: name; addLast: $''.
  ]
].

" instVarNames: #( <list of strings> ) "

newByteSubclass ifFalse: [
  result addAll: lfsp;
    addAll: ''instVarNames: #('';
    addAll: (self _instVarNamesWithSeparator: (lfsp , ''                 ''));
    add: $).
].

" classVars: #( <list of strings> ) "
result addAll: lfsp; addLast: ''classVars: #(''.
self _sortedClassVarNames do: [:aKey |
  result addLast: $  . 
  (aKey includesValue: $'') 
    ifTrue:[ result addAll: aKey _asSource ]
    ifFalse:[ result addAll: aKey ].
  ].
result addLast: $).

" classInstVars: #( <list of strings> ) "

result addAll: lfsp; addLast: ''classInstVars: #(''.
civs := self class allInstVarNames.
civs removeFrom: 1 to: (self class superClass instSize).
civs do: [:civName |
  result addLast: $  .
  (civName includesValue: $'') 
    ifTrue:[ result addAll: civName _asSource ]
    ifFalse:[ result addAll: civName ].
].
result addLast: $).

" poolDictionaries: #[ <list of dictionary names> ] "

inv := poolDictionaries isKindOf: InvariantArray.
result addAll: lfsp; addAll: ''poolDictionaries: #''.

result add: (inv ifTrue: [ $( ] ifFalse: [ $[ ]).

firstElement := true.
self sharedPools do: [:each |
  firstElement ifFalse: [ result addAll: '', ''].  "separate with commas"
  anArray := aUserProfile dictionaryAndSymbolOf: each.
  anArray == nil
        ifTrue: [ result addAll: '' "(not named)" '' ]
        ifFalse: [ result addAll: (anArray at: 2)].
  firstElement := false.
].

result add: (inv ifTrue: [ $) ] ifFalse: [ $] ]).

" inDictionary: <name of containing dictionary> "

result addAll: lfsp; addAll: ''inDictionary: ''.
anArray := aUserProfile dictionaryAndSymbolOf: self.
anArray == nil ifTrue: [
  result addAll: ''(class not in your dictionaries)''
]
ifFalse: [
  anArray := aUserProfile dictionaryAndSymbolOf: (anArray at: 1).
  anArray == nil ifTrue: [
    result addAll: ''(dictionary not in your dictionaries)''
  ]
  ifFalse: [
    result addAll: (anArray at: 2)
  ]
].

" constraints: #[ <Array of instance-variable-symbol/class-name pairs> ]
    or
  constraints: <class name> "

newByteSubclass ifFalse: [
  result addAll: lfsp; addAll: ''constraints: ''.
  (constraints isKindOf: Array ) ifTrue: [
    result addAll: ''#[ ''.
    firstElement := true.
    1 to: instVars do: [ :x |
      aConstraint := constraints at:x .
      ((aConstraint ~~ nil _and: [aConstraint ~~ Object]) 
          _and:[ superClass == nil 
            _or:[ (superClass _namedIvConstraintAt: x) ~~ aConstraint ]] )
      ifTrue: [
        " if not the first constraint, prefix with a comma to separate
          from the last constraint "
        firstElement ifFalse: [
          result addLast: $,; addAll: lfsp; addAll: ''                ''
        ]
        ifTrue: [
          firstElement := false
        ].
        result addAll: ''#[ #''; addAll: (instVarNames at: x) ;
              addAll: '', ''; addAll: aConstraint name; addLast: $] .
      ]
    ].
    aConstraint:= self varyingConstraint .
    ( (aConstraint ~~ Object) _and:
        [(superClass varyingConstraint) ~~ aConstraint] )
    ifTrue:[
      firstElement ifFalse: [
          result addLast: $,; addAll: lfsp; addAll: ''                ''
      ]
      ifTrue: [
        firstElement := false
      ].
      result addAll: ''   "the elements"  ''; addAll: aConstraint name
    ].
    result addAll: '' ]''.
  ]
  ifFalse: [
    constraints class class == Metaclass ifTrue: [
      result addAll: constraints name.
    ]
    ifFalse: [
      result addAll: '' nil''
    ].
  ].

    " instancesInvariant: "

  result addAll: lfsp;
    addAll: ''instancesInvariant: '';
    addAll: (self instancesInvariant describe).

    " instancesInvariant: aBoolean "

  result addAll: lfsp;
    addAll: ''isModifiable: ''; addAll: (self isModifiable describe).
]
ifTrue: [ "a Byte subclass"

    " instancesInvariant: aBoolean "                           "fix 9763"

  result addAll: lfsp;
    addAll: ''instancesInvariant: ''; addAll: (self instancesInvariant describe).
].

result add: Character lf.
^result
'.
			"2.4.5"
			#'_definitionInContext:' -> '_definitionInContext: aUserProfile

"Returns a description of the receiver using object names taken from the given
 UserProfile."

| result newByteSubclass anArray lfsp
  aConstraint firstElement inv civs |

result := String new.
result addAll: (superClass == nil ifTrue: [''nil''] ifFalse: [superClass name]).

newByteSubclass := false.
lfsp := (Character lf asString) addAll: ''  ''; yourself.


(self isBytes _and: [superClass isBytes not]) ifTrue: [
  result addAll: '' byteSubclass: ''''''; addAll: name; addLast: $''.
  newByteSubclass := true.
]
ifFalse: [
  (self isIndexable _and: [superClass isIndexable not]) ifTrue: [
    result addAll: '' indexableSubclass: ''''''; addAll: name; addLast: $''.
  ]
  ifFalse: [
    result addAll: '' subclass: ''''''; addAll: name; addLast: $''.
  ]
].

" instVarNames: #( <list of strings> ) "

newByteSubclass ifFalse: [
  result addAll: lfsp;
    addAll: ''instVarNames: #('';
    addAll: (self _instVarNamesWithSeparator: (lfsp , ''                 ''));
    add: $).
].

" classVars: #( <list of strings> ) "
result addAll: lfsp; addLast: ''classVars: #(''.
self _sortedClassVarNames do: [:aKey |
  result addLast: $  . 
  (aKey includesValue: $'') 
    ifTrue:[ result addAll: aKey _asSource ]
    ifFalse:[ result addAll: aKey ].
  ].
result addLast: $).

" classInstVars: #( <list of strings> ) "

result addAll: lfsp; addLast: ''classInstVars: #(''.
civs := self class allInstVarNames.
civs removeFrom: 1 to: (self class superClass instSize).
civs do: [:civName |
  result addLast: $  .
  (civName includesValue: $'') 
    ifTrue:[ result addAll: civName _asSource ]
    ifFalse:[ result addAll: civName ].
].
result addLast: $).

" poolDictionaries: #[ <list of dictionary names> ] "

inv := poolDictionaries isKindOf: InvariantArray.
result addAll: lfsp; addAll: ''poolDictionaries: #''.

result add: (inv ifTrue: [ $( ] ifFalse: [ $[ ]).

firstElement := true.
self sharedPools do: [:each |
  firstElement ifFalse: [ result addAll: '', ''].  "separate with commas"
  anArray := aUserProfile dictionaryAndSymbolOf: each.
  anArray == nil
        ifTrue: [ result addAll: '' "(not named)" '' ]
        ifFalse: [ result addAll: (anArray at: 2)].
  firstElement := false.
].

result add: (inv ifTrue: [ $) ] ifFalse: [ $] ]).

" inDictionary: <name of containing dictionary> "

result addAll: lfsp; addAll: ''inDictionary: ''.
anArray := aUserProfile dictionaryAndSymbolOf: self.
anArray == nil ifTrue: [
  result addAll: ''(class not in your dictionaries)''
]
ifFalse: [
  anArray := aUserProfile dictionaryAndSymbolOf: (anArray at: 1).
  anArray == nil ifTrue: [
    result addAll: ''(dictionary not in your dictionaries)''
  ]
  ifFalse: [
    result addAll: (anArray at: 2)
  ]
].

" constraints: #[ <Array of instance-variable-symbol/class-name pairs> ]
    or
  constraints: <class name>
  constraints are deprecated - only add if they are present.
  Byte subclasses don''t have instVars thus no constraints"

newByteSubclass ifFalse: [
  self _hasConstraints ifTrue: [
    result add: self _definitionOfConstraints.
    ]
  ].

result addAll: lfsp;
  addAll: ''instancesInvariant: '';
  addAll: (self instancesInvariant describe).

newByteSubclass ifFalse: [		"Byte subclasses don''t have instVars so can''t be modifiable"
  result addAll: lfsp;
    addAll: ''isModifiable: ''; addAll: (self isModifiable describe).
].

result add: Character lf.
^result
'.
	}