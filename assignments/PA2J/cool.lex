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
            yybegin(YYINITIAL);
            return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString("EOF in comment"));
        case STRING:
            yybegin(YYINITIAL);
            return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString("EOF in string"));
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
WHITESPACE=[ \f\r\t\v]
NEWLINE=\n|\r|\r\n
SPECIAL_ID=(Object|Int|Bool|String|SELF_TYPE|self)
%state COMMENT
%state STRING
%state STRING_ERROR

%%

<YYINITIAL>{NEWLINE}                             { curr_lineno++; }
<YYINITIAL>"\*"                        { return new Symbol(TokenConstants.MULT);}
<YYINITIAL>"(?i:inherits)"             { return new Symbol(TokenConstants.INHERITS);}
<YYINITIAL>"(?i:pool)"                 { return new Symbol(TokenConstants.POOL);}
<YYINITIAL>"(?i:case)"                 { return new Symbol(TokenConstants.CASE);}
<YYINITIAL>"("                         { return new Symbol(TokenConstants.LPAREN);}
<YYINITIAL>";"                         { return new Symbol(TokenConstants.SEMI);}
<YYINITIAL>"-"                         { return new Symbol(TokenConstants.MINUS);}
<YYINITIAL>"\""                        { yybegin(STRING); 
                                         string_buf.delete(0, string_buf.length());}
<STRING>\n                             { curr_lineno++; }
<STRING>"\n"                           { 
                                         if (string_buf.length() < MAX_STR_CONST) { 
                                            string_buf.append("\n"); 
                                         } else {
                                            yybegin(STRING_ERROR);
                                            return new Symbol(TokenConstants.ERROR, "String constant too long");
                                         }
                                       }
<STRING>"\b"                           { if (string_buf.length() < MAX_STR_CONST) { 
                                            string_buf.append("\b"); 
                                         } else {
                                            yybegin(STRING_ERROR);
                                            return new Symbol(TokenConstants.ERROR, "String constant too long");
                                         }
                                       }
<STRING>"\t"                           { if (string_buf.length() < MAX_STR_CONST) { 
                                            string_buf.append("\t"); 
                                         } else {
                                            yybegin(STRING_ERROR);
                                            return new Symbol(TokenConstants.ERROR, "String constant too long");
                                         }
                                       }
<STRING>"\f"                           { if (string_buf.length() < MAX_STR_CONST) { 
                                            string_buf.append("\f"); 
                                         } else {
                                            yybegin(STRING_ERROR);
                                            return new Symbol(TokenConstants.ERROR, "String constant too long");
                                         }
                                       }

<STRING>[^\"\\]                        { if (string_buf.length() < MAX_STR_CONST) { 
                                            string_buf.append(yytext()); 
                                         } else {
                                            yybegin(STRING_ERROR);
                                            return new Symbol(TokenConstants.ERROR, "String constant too long");
                                         }
                                       }
<STRING>"\0"                           { if (string_buf.length() < MAX_STR_CONST) { 
                                            string_buf.append("0"); 
                                         } else {
                                            yybegin(STRING_ERROR);
                                            return new Symbol(TokenConstants.ERROR, "String constant too long");
                                         }
                                       }
<STRING>"\""                           { yybegin(YYINITIAL); 
                                         return new Symbol(TokenConstants.STR_CONST, AbstractTable.stringtable.addString(string_buf.toString()));}
<STRING>\0                            { yybegin(STRING_ERROR); return new Symbol(TokenConstants.ERROR, "String contains null character");}
<STRING_ERROR>.*                      { ; }
<STRING_ERROR>\n                      { curr_lineno++; 
                                        yybegin(YYINITIAL); }
<STRING_ERROR>"\""                    { yybegin(YYINITIAL); }


<YYINITIAL>")"                         { return new Symbol(TokenConstants.RPAREN);}
<YYINITIAL>"not"                       { return new Symbol(TokenConstants.NOT);}
<YYINITIAL>{UPPERCASE}{ID_LETTERS}*    { return new Symbol(TokenConstants.TYPEID, AbstractTable.idtable.addString(yytext()));}
<YYINITIAL>"<"                         { return new Symbol(TokenConstants.LT);}
<YYINITIAL>"(?i:in)"                   { return new Symbol(TokenConstants.IN);}
<YYINITIAL>","                         { return new Symbol(TokenConstants.COMMA);}
<YYINITIAL>"(?i:class)"                { return new Symbol(TokenConstants.CLASS);}
<YYINITIAL>"(?i:fi)"                   { return new Symbol(TokenConstants.FI);}
<YYINITIAL>"/"                         { return new Symbol(TokenConstants.DIV);}
<YYINITIAL>"(?i:loop)"                 { return new Symbol(TokenConstants.POOL);}
<YYINITIAL>"+"                        { return new Symbol(TokenConstants.PLUS);}
<YYINITIAL>"<-"                        { return new Symbol(TokenConstants.ASSIGN);}
<YYINITIAL>"(?i:if)"                   { return new Symbol(TokenConstants.IF);}
<YYINITIAL>"."                         { return new Symbol(TokenConstants.DOT);}
<YYINITIAL>"<="                        { return new Symbol(TokenConstants.LE);}
<YYINITIAL>"(?i:of)"                   { return new Symbol(TokenConstants.OF);}

<YYINITIAL>{DIGIT}+                    { return new Symbol(TokenConstants.INT_CONST, AbstractTable.inttable.addString(yytext()));}
<YYINITIAL>"(?i:new)"                  { return new Symbol(TokenConstants.NEW);}

<YYINITIAL>"(?i:isvoid)"               { return new Symbol(TokenConstants.ISVOID);}
<YYINITIAL>"="                         { return new Symbol(TokenConstants.EQ);}

<YYINITIAL>":"                         { return new Symbol(TokenConstants.COLON);}
<YYINITIAL>"~"                         { return new Symbol(TokenConstants.NEG);}
<YYINITIAL>"{"                         { return new Symbol(TokenConstants.LBRACE);}
<YYINITIAL>"(?i:else)"                 { return new Symbol(TokenConstants.ELSE);}
<YYINITIAL>"=>"			    { return new Symbol(TokenConstants.DARROW);}
<YYINITIAL>"(?i:while)"                  { return new Symbol(TokenConstants.WHILE);}
<YYINITIAL>"(?i:esac)"                  { return new Symbol(TokenConstants.ESAC);}
<YYINITIAL>"(?i:let)"                  { return new Symbol(TokenConstants.LET);}
<YYINITIAL>"}"                         { return new Symbol(TokenConstants.RBRACE);}

<YYINITIAL>"(?i:then)"                 { return new Symbol(TokenConstants.THEN);}
<YYINITIAL>"f(?i:alse)"                { return new Symbol(TokenConstants.BOOL_CONST, false);}
<YYINITIAL>"t(?i:rue)"                 { return new Symbol(TokenConstants.BOOL_CONST, true);}
<YYINITIAL>{LOWERCASE}{ID_LETTERS}*    { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext()));}
<YYINITIAL>SPECIAL_ID                  { return new Symbol(TokenConstants.OBJECTID, AbstractTable.idtable.addString(yytext()));}
<YYINITIAL>"@"                           { return new Symbol(TokenConstants.AT);}
<YYINITIAL>"--".*                      { /* jump to next line */ ;}
<YYINITIAL>"(*"                        { yybegin(COMMENT);}
<COMMENT>\n                            {  curr_lineno++; }
<COMMENT>([^\n)*])*                    { ;}
<COMMENT>"*)"                          { yybegin(YYINITIAL);}
<YYINITIAL>"*)"                        { return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString("Unmatched )*"));}
<YYINITIAL>{WHITESPACE}+               { ;/* no action for whitespace */}
.                                      { /* This rule should be the very last
                                            in your lexical specification and
                                            will match match everything not
                                            matched by other lexical rules. */
                                         System.err.println("LEXER BUG - UNMATCHED: " + yytext()); 
                                         return new Symbol(TokenConstants.ERROR, AbstractTable.stringtable.addString(yytext()));}

