/*
*	JFlex lesgreinir fyrir ohprom.
*	Höfundur:	Snorri Agnarsson
*				Gísli Freyr Brynjarsson
*/

%%

%public
%class ohpromLexer
%unicode
%byaccj
%line
%column
%x COMMENT

%{

int nesting = 0;

public ohpromParser yyparser;

public ohpromLexer (java.io.Reader r, ohpromParser yyparser) {
	this(r);
	this.yyparser = yyparser;
}

public int getLine() {
	return yyline;
}

public int getColumn() {
	return yycolumn;
}

%}

_DIGIT=		[0-9]
_INT=		{_DIGIT}+
_FLOAT=		{_DIGIT}+\.{_DIGIT}([eE][+-]?{_DIGIT}+)?
_OPCHAR=	[\+\-*/!%&=><\:\^\~&|?]
_OP=		{_OPCHAR}+
_STRING=	\"([^\"\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|\\[0-7][0-7]|\\[0-7])*\"
_CHAR=		\'([^\'\\]|\\b|\\t|\\n|\\f|\\r|\\\"|\\\'|\\\\|(\\[0-3][0-7][0-7])|(\\[0-7][0-7])|(\\[0-7]))\'
_DELIMS=	[(){}\[\],;.$#\!=]
_ALPHA=		[:letter:]
_NAME=		(_|{ALPHA})(_|{ALPHA}|{DIGIT})*
_LITERAL=	{_FLOAT}|{_INT}|{_STRING}|{_CHAR}|"true"|"false"|"null"

%%

{_LITERAL} {
	yyparser.yylval = new ohpromParserVal(yytext());
	return ohpromParser.LITERAL
}

"RO" {
	return ohpromParser.RO;
}

"DNA" {
	return ohpromParser.DNA;
}

"TON" {
	return ohpromParser.NOT;
}

{_DELIM} {
	yyohpromParser.yylval = new ohpromParserVal(yytext());
	return yycharat(0);
}

{_OP} {
	yyparser.yylval = new ohpromParserVal(yytext());
	switch (yycharat(0)) {
		case '?':
		case '~':
		case '^':
			return ohpromParser.BINOP1;
		case ':':
			return ohpromParser.BINOP2;
		case '|':
			return ohpromParser.BINOP3;
		case '&':
			return ohpromParser.BINOP4;
		case '=':
		case '<':
		case '>':
		case '!':
			return ohpromParser.BINOP5;
		case '+':
		case '-':
			return ohpromParser.BINOP6;
		default:
			return ohpromParser.BINOP7;
	}
}

"fi" {
	return ohpromParser.IF;
}
"esel" {
	return ohpromParser.ELSE;
}
"file" {
	return ohpromParser.ELIF;
}
"elihw" {
	return ohpromParser.WHILE;
}
"rav" {
	return ohpromParser.VAR;
}
"nruter" {
	return ohpromParser.RETURN;
}

{_NAME} {
	yyparser.yylval = new ohpromParserVal(yytext());
	return ohpromParser.NAME;
}

";;;".*$ {
}

"{;;;" {
	yybegin(COMMENT); nesting++;
}

<COMMENT>"{;;;" {
	nesting++;
}

<COMMENT>";;;}" {
	if (--nesting==0) {
		yybegin(YYINITIAL);
	}
}

<COMMENT>.|\n {
	/* ignore */
}

[\t\r\n\f] {
}

. {
	return ohpromParser.YYERRCODE;
}
