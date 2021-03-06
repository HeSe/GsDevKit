utilties
compileRegex: aString
	"Compile the regex and answer the matcher, or answer nil if compilation fails."

	| syntaxTree |
	syntaxTree := self parserClass safelyParse: aString.
	^ syntaxTree isNil ifFalse: [ self matcherClass for: syntaxTree ]