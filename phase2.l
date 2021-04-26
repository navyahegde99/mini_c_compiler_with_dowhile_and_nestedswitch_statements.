%option yylineno

%{
	#include<stdio.h>
	#include"y.tab.h"
	#include<math.h>
	int lno=1;
	int tok_count=0;
	char tokval[100];
	char idname[100];
	char dectype[100];
	int no_of_entries = 0;
	int scope = 0;
	int enc_lno[100] = {0};
%}


%%
"#include"([ ]+)?((<(\\.|[^>])+>)|(\"(\\.|[^"])+\")) {fputs(yytext, yyout);++tok_count;return HEADER;}
"#define"[ ]+[a-zA-Z_][a-zA-Z_0-9]* {fputs(yytext, yyout);++tok_count;return DEFINE;}
"void"|"char"|"short"|"int"|"long"|"float"|"double"|"signed"|"unsigned" {fputs(yytext, yyout);++tok_count;strcpy(dectype, yytext);return TYPE_CONST;}							
"case"																										{fputs(yytext, yyout);++tok_count;return CASE;}	
"default"																									{fputs(yytext, yyout);++tok_count;return DEFAULT;}
"switch"																									{fputs(yytext, yyout);++tok_count;return SWITCH;}
"else"																										{fputs(yytext, yyout);++tok_count;enc_lno[scope] = lno;return ELSE;}
"do"																										{fputs(yytext, yyout);++tok_count;return DO;}
"while"																										{fputs(yytext, yyout);++tok_count;return WHILE;}
"continue"																									{fputs(yytext, yyout);++tok_count;return CONTINUE;}
"break"																										{fputs(yytext, yyout);++tok_count;return BREAK;}
"return"																									{fputs(yytext, yyout);++tok_count;return RETURN;}
"||" 																										{fputs(yytext, yyout);++tok_count;return OR_CONST;}
"&&"																										{fputs(yytext, yyout);++tok_count;return AND_CONST;}
"=="																										{fputs(yytext, yyout);++tok_count;return E_CONST;}
"!="																										{fputs(yytext, yyout);++tok_count;return NE_CONST;}
"<="																										{fputs(yytext, yyout);++tok_count;return LE_CONST;}
">="																										{fputs(yytext, yyout);++tok_count;return GE_CONST;}
"<"																											{fputs(yytext, yyout);++tok_count;return L_CONST;}
">"																											{fputs(yytext, yyout);++tok_count;return G_CONST;}
">>"																										{fputs(yytext, yyout);++tok_count;return RSHIFT_CONST;}
"<<"																										{fputs(yytext, yyout);++tok_count;return LSHIFT_CONST;}
"++"																										{fputs(yytext, yyout);++tok_count;return INC_CONST;}
"--"																										{fputs(yytext, yyout);++tok_count;return DEC_CONST;}

"{"																											{fputs(yytext, yyout);++tok_count;return OPEN_SCOPE;}
"}"																											{fputs(yytext, yyout);++tok_count;return CLOSE_SCOPE;}

";"|"="|","|"("|")"|"["|"]"|"*"|"+"|"-"|"/"|"?"|":"|"&"|"|"|"^"|"!"|"~"|"%" 								{fputs(yytext, yyout);++tok_count;return yytext[0];}
"*="																										{fputs(yytext, yyout);++tok_count;return MUL_EQ;}
"/="																										{fputs(yytext, yyout);++tok_count;return DIV_EQ;}
"+="																										{fputs(yytext, yyout);++tok_count;return ADD_EQ;}
"%="																										{fputs(yytext, yyout);++tok_count;return PER_EQ;}
">>="																										{fputs(yytext, yyout);++tok_count;return RS_EQ;}
"-="																										{fputs(yytext, yyout);++tok_count;return SUB_EQ;}
"<<="																										{fputs(yytext, yyout);++tok_count;return LS_EQ;}
"&="																										{fputs(yytext, yyout);++tok_count;return AND_EQ;}
"^="																										{fputs(yytext, yyout);++tok_count;return XOR_EQ;}
"|="																										{fputs(yytext, yyout);++tok_count;return OR_EQ;}
[0-9]+																										{fputs(yytext, yyout);strcpy(tokval, yytext);++tok_count;yylval.val = atoi(yytext);return INT;}
[0-9]+"."[0-9]+																								{fputs(yytext, yyout);strcpy(tokval, yytext);++tok_count;yylval.fval = atof(yytext);return FLOAT;}	
"'"."'"																										{fputs(yytext, yyout);strcpy(tokval, yytext);++tok_count;yylval.cval = yytext[1];return CHAR;}
[a-zA-Z_][a-zA-Z0-9_]*			 																			{fputs(yytext, yyout);strcpy(idname, yytext);++tok_count;return id;}
\"(\\.|[^\"])*\"																							{fputs(yytext, yyout);strcpy(tokval, yytext);++tok_count;return string;}
"//"(\\.|[^\n])*[\n]																						;
[/][*]([^*]|[*]*[^*/])*[*]+[/]                                                                              ;
[ \t]																										{fputs(yytext, yyout);}
\n																											{fprintf(yyout, "\n%d ",++lno);}
[ ]+																										;
[\n]+																										{fprintf(yyout, "\n%d ",++lno);}
[\t]+ 																										{fprintf(yyout, "\t");}
%%

int yywrap(void)
{
	//printf("Token count is %d\n",tok_count);
    return 1;
}
