%{
#include <string.h>
#include "aulaAST.tab.h"
%}

NUM [0-9]+\.?[0-9]*
VARS [a-zA-Z_][a-zA-Z0-9_]*
FIM "FIM"
IF "IF"
ELSE "ELSE"
WHILE "WHILE"
PRINT "PRINT"
PRINTT "PRINTT"
SCAN "LER"
SCANS "LERS"
DECL "var"
INT "int"
FLOAT "float"
STRING "string"
COMMENT "//".*

%%
{FIM} {return FIM;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{PRINTT} {return PRINTT;}
{PRINT} {return PRINT;}
{SCAN} {return SCAN;}
{SCANS} {return SCANS;}
{DECL} {return DECL;}
{INT} {return INT;}
{FLOAT} {return FLOAT;}
{STRING} {return STRING;}

{VARS} {
    strcpy(yylval.str,yytext);
    return VARS;
}

{NUM} {
    yylval.flo = atof(yytext);
    return NUM;
}

{COMMENT} { /* Ignore comments */ }

">" {yylval.fn = 1; return CMP; }
"<" {yylval.fn = 2; return CMP; }
"<>" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }

[-+()=/*^{};\[\],] {return *yytext;}

[\ \n\t]* {;}
. {printf("(%s) Ignorado\n",yytext);}
%%