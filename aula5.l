%{
 	#include <string.h>
%}

/* Expressões Regulares */
NUM [0-9]+\.?[0-9]*
TEXTO [A-Za-z] 
VAR [a-z]+[0-9]*
DECL "var"
PRINT "PRINT"
INI "INICIO"
FIM "FIM"
SCAN "SCAN"
IF "IF"
ELSE "ELSE"
WHILE "WHILE"
PRINTT "PRINTT"
SCANS "SCANS"
	
/* Tokens */
%%

{FIM} {return FIM;}
{INI} {return INICIO;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{WHILE} {return WHILE;}
{PRINTT} {return PRINTT;}
{PRINT} {return PRINT;}
{SCAN} {return SCAN;}
{SCANS} {return SCANS;}
{DECL} {return DECL;}

{VARS} {
	strcpy(yylval.str,yytext);
	return VARS;
	}

{NUM} {
	yylval.flo = atof(yytext);
	return NUM;
	}

{TEXTO} {
	strcpy(yylval.str,yytext);
	return TEXTO;
	}

\"([^\"\\]|\\.)*\"  { 
	strncpy(yylval.str, yytext + 1, sizeof(yylval.str) - 1); 
	yylval.str[strlen(yylval.str) - 1] = '\0'; 
	return STRING; 
}

[-+()=/*^{};\[\]] {return *yytext;}
			

">"  {yylval.fn = 1; return CMP; }
"<"  {yylval.fn = 2; return CMP; }
"<>" {yylval.fn = 3; return CMP; }
"==" {yylval.fn = 4; return CMP; }
">=" {yylval.fn = 5; return CMP; }
"<=" {yylval.fn = 6; return CMP; }
"&&" {yylval.fn = 7; return CMP; }
"||" {yylval.fn = 8; return CMP; }
"!=" {yylval.fn = 9; return CMP; }

"." {yylval.fn = 10; return SIMB; }
"," {yylval.fn = 11; return SIMB; }
"#" {yylval.fn = 12; return SIMB; }
":" {yylval.fn = 13; return SIMB; }
"?" {yylval.fn = 14; return SIMB; }
"!" {yylval.fn = 15; return SIMB; }
"%" {yylval.fn = 16; return SIMB; }

[\ \n\t]*	{;}
. {printf("(%s) Ingonrado\n",yytext);}

%%


