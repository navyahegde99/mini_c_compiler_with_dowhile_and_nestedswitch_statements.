%{
#include<stdio.h>
extern FILE *yyin;
%}

%%
"#include<stdio.h>"|"#include<stdlib.h>"|"#include<string.h>"|"#include<math.h>"	{ECHO;printf("\n<TOKEN,PREROCESSOR>\n");}
auto|double|int|struct|break|else|long|switch|case|enum|register|typedef|char|extern|return|union|continue|for|signed|void|do|if|static|while|default|goto|sizeof|volatile|const|float|short    {ECHO;printf("\n<TOKEN,KEYWORD>\n");}  					
[{};,()]   {ECHO;printf("\n<TOKEN,SEPERATOR>\n");}						
[+-/=*%]   {ECHO;printf("\n<TOKEN,OPERATOR>\n");}						
([a-zA-Z][0-9])+|[a-zA-Z]* {ECHO; printf("\n<TOKEN,Identifier>\n");}    
.|\n ; 	
(\/\/) {;}
"/*"[^\n]+"*/" {;}
(\/\*.*\*\/) {;}	
														
%%

/*call the yywrap function*/
int yywrap()								
{
return 1;
}

int main(int argc,char **argv)
{
yyin=fopen(argv[1],"r");
yylex();
fclose(yyin);
return 0;
}

