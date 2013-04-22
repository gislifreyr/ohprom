all: ohpromLexer.class ohpromParser.class ohpromParserVal.class

test: all test.ohp
	java ohpromParser test.ohp > test.masm
	morpho -c test.masm
	morpho test

ohpromLexer.class ohpromParser.class ohpromParserVal.class: ohpromLexer.java ohpromParser.java ohpromParserVal.java
	javac ohpromLexer.java ohpromParser.java ohpromParserVal.java

ohpromLexer.java: ohprom.jflex
	java -jar JFlex.jar ohprom.jflex

ohpromParser.java ohpromParserVal.java: ohprom.byaccj
	byaccj -Jclass=ohpromParser ohprom.byaccj

clean:
	rm -rf *.class *~ *.java *.bak yacc.*
