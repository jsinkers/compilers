/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{
//  Declarations: helper functions 
/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. 
 */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  
 */

    switch(yy_lexical_state) {
        case YYINITIAL:
            /* nothing special to do in the initial state */
            break;
        /* If necessary, add code for other states here, e.g: */
        case COMMENT:
            //return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString("EOF in comment"));
            // how to return error and still return EOF symbol?
            System.err.println("EOF in comment");
            return new Symbol(TokenConstants.EOF, AbstractTable.stringtable.addString("EOF in comment"));
            //break;
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

DIGIT=[0-9]
LETTER=[a-zA-Z]
LOWERCASE=[a-z]
UPPERCASE=[A-Z]
ID_LETTERS=({LETTER}|{DIGIT}|_)
WHITESPACE=[ \n\f\r\t\v]
SPECIAL_ID=(Object|Int|Bool|String|SELF_TYPE|self)
%state COMMENT
%state IF
%state PAREN

%%

"\*"                        { return new Symbol(TokenConstants.MULT);}
"(?i:inherits)"             { return new Symbol(TokenConstants.INHERITS);}
"(?i:pool)"                 { return new Symbol(TokenConstants.POOL);}
"(?i:case)"                 { return new Symbol(TokenConstants.CASE);}
"("                        { yybegin(PAREN);
                              return new Symbol(TokenConstants.LPAREN);}
";"                         { return new Symbol(TokenConstants.SEMI);}
"-"                         { return new Symbol(TokenConstants.MINUS);}

<PAREN>")"                 { yybegin(YYINITIAL); 
                              return new Symbol(TokenConstants.RPAREN);}
{UPPERCASE}{ID_LETTERS}*    { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext()));}
"<"                         { return new Symbol(TokenConstants.LT);}
"(?i:in)"                   { return new Symbol(TokenConstants.IN);}
","                         { return new Symbol(TokenConstants.COMMA);}
"(?i:class)"                { return new Symbol(TokenConstants.CLASS);}
<IF>"(?i:fi)"               { yybegin(YYINITIAL); 
                              return new Symbol(TokenConstants.FI);}

"(?i:loop)"                 { return new Symbol(TokenConstants.POOL);}
"\+"                        { return new Symbol(TokenConstants.PLUS);}
"<-"                        { return new Symbol(TokenConstants.ASSIGN);}
"(?i:if)"                   { yybegin(IF); 
                              return new Symbol(TokenConstants.IF);}
"<="                        { return new Symbol(TokenConstants.LE);}
"(?i:of)"                   { return new Symbol(TokenConstants.OF);}

{DIGIT}+                    { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext()));}
"(?i:new)"                  { return new Symbol(TokenConstants.NEW);}

"(?i:isvoid)"               { return new Symbol(TokenConstants.ISVOID);}
"="                         { return new Symbol(TokenConstants.EQ);}

":"                         { return new Symbol(TokenConstants.COLON);}

"{"                         { return new Symbol(TokenConstants.LBRACE);}
<IF>"(?i:else)"             { return new Symbol(TokenConstants.ELSE);}
<YYINITIAL>"=>"			    { return new Symbol(TokenConstants.DARROW);}
"(?i:while)"                  { return new Symbol(TokenConstants.WHILE);}
"(?i:esac)"                  { return new Symbol(TokenConstants.ESAC);}
"(?i:let)"                  { return new Symbol(TokenConstants.LET);}

"}"                         { return new Symbol(TokenConstants.RBRACE);}

<IF>"(?i:then)"             { return new Symbol(TokenConstants.THEN);}
"f(?i:alse)"                { return new Symbol(TokenConstants.BOOL_CONST, false);}
"t(?i:rue)"                 { return new Symbol(TokenConstants.BOOL_CONST, true);}
{LOWERCASE}{ID_LETTERS}*    { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext()));}
SPECIAL_ID                  { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext()));}

"--".*                      { /* jump to next line */ ;}
"(*"                        { yybegin(COMMENT);}
<COMMENT>([^")"*])*         { ;}
<COMMENT>"*)"               { yybegin(YYINITIAL);}
"*)"                        { return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString("Unmatched )*"));}
{WHITESPACE}+               { ;/* no action for whitespace */}
.                           { /* This rule should be the very last
                                 in your lexical specification and
                                 will match match everything not
                                 matched by other lexical rules. */
                                // System.err.println("LEXER BUG - UNMATCHED: " + yytext()); 
                                return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString(yytext()));}
