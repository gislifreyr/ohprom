all: ohpromLexer.class ohpromParser.class ohpromParserVal.class

test: all test.test
	java ohpromParser test.test > test.masm
	java -jar morpho.jar -c test.masm
	java -jar morpho.jar test

ohpromLexer.class ohpromParser.class ohpromParserVal.class: ohpromLexer.java ohpromParser.java ohpromParserVal.java
	javac ohpromLexer.java ohpromParser.java ohpromParserVal.java

ohpromLexer.java: morpho.jflex
	java -jar JFlex.jar morpho.jflex

ohpromParser.java ohpromParserVal.java: morpho.byaccj
	byaccj -Jclass=ohpromParser morpho.byaccj

clean:
	rm -rf *.class *~ *.java *.bak yacc.*
