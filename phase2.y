%{
	#include<stdio.h>
	#include<string.h>
	#include<stdlib.h>
	#include "newSymbolTable.h"
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	char name[100];
	// All extern variables


	//TO-DO - Store a stack of scope values along with their enclosing line numbers.
	extern int enc_lno[100];
	extern int no_of_entries;
	extern char tokval[100];
	extern char idname[100];
	extern int lno;
	extern int scope;
	int array = 0;
	// Declaration type of variables
	extern char dectype[100];
%}

%token <val> INT 
%token <cval> CHAR
%token <fval> FLOAT 
%token string id TYPE_CONST DEFINE OPEN_SCOPE CLOSE_SCOPE
%token IF FOR DO WHILE BREAK SWITCH CONTINUE RETURN CASE DEFAULT GOTO SIZEOF OR_CONST AND_CONST E_CONST NE_CONST LE_CONST GE_CONST G_CONST L_CONST LSHIFT_CONST MUL_EQ DIV_EQ ADD_EQ PER_EQ RS_EQ SUB_EQ LS_EQ AND_EQ XOR_EQ OR_EQ RSHIFT_CONST REL_CONST INC_CONST DEC_CONST ELSE HEADER Initialization

%right '='
%left '+' '-'
%left '*' '/'

%union{
	int val;
	float fval;
	char cval;
}


%start program_unit
%%
program_unit				: HEADER program_unit                             
							| DEFINE primary_expression program_unit                 	
							| translation_unit									
							;
translation_unit			: external_decl 									
							| translation_unit external_decl					
							;
external_decl				: function_definition
							| decl
							| compound_stat
							;
function_definition			: type_spec declarator compound_stat 	
							| declarator compound_stat 
							;
decl						: type_spec init_declarator_list ';'							
							;
type_spec					: TYPE_CONST 
							;
init_declarator_list		: init_declarator 						
							| init_declarator_list ',' init_declarator
							;
init_declarator				: declarator 
							{								
								strcpy(tokval, "&*&*^&^");
								if(strcmp(dectype, "int")==0 && scope==0){
									strcpy(tokval, "0");
								}
								int k = search((char*)name, dectype, scope, enc_lno[scope], 1); 
								if(k==-1)
									s[no_of_entries++] = init_node((char*)name,scope,lno,dectype, enc_lno[scope], tokval);
								else if(k==-2){
									printf("Error at line number : %d - REDECLARATION\n", lno);
									printf("Aborting...\n");
									exit(0);
								}
							}
							| declarator '=' initializer 
							{
								char val[100];
								sprintf(val, "%d", $<val>3);
								//printf("\nInitialization %s =%s\n\n", name, val);
								int k = search((char*)name, dectype, scope, enc_lno[scope], 1); 
								if(k==-1)
									s[no_of_entries++] = init_node((char*)name,scope,lno,dectype, enc_lno[scope], val);
								else if(k==-2){
									printf("Error at line number : %d - REINITIALIZATION\n", lno);
									printf("Aborting...\n");
									exit(0);
								}
								else
									update(k, tokval);
							}
							;
spec_qualifier_list			: type_spec spec_qualifier_list
							| type_spec
							;
declarator					: id {strcpy(name, idname);}							
							| '('declarator')'									
							| declarator'['const_expression']'
							{
								//char num[100];
								//sprintf(num, "%d", $3);
								strcat(dectype, (char*)"[");
								//strcat(dectype, num);
								strcat(dectype, (char*)"]");
							}					
							| declarator '['	']'
							{
								strcat(dectype, (char*)"[]");
							}
							| declarator '(' param_type_list ')' 
							{
								strcpy(tokval, "-");
								
								enc_lno[scope] = lno;
								s[no_of_entries++] = init_node((char*)name,scope,lno,"FUNC", enc_lno[scope], tokval);	
							}			
							| declarator '(' func_call_params ')' 					
							| declarator '('	')' 
							{
								strcpy(tokval, "-");
								
								enc_lno[scope] = lno;
								s[no_of_entries++] = init_node((char*)name,scope,lno,"FUNC", enc_lno[scope], tokval);
							}							
							;
param_type_list				: param_list
							;
param_list					: param_decl
							| param_list ',' param_decl
							;
param_decl					: type_spec declarator
							| type_spec abstract_declarator
							| type_spec
							;
func_call_params			: id
							| func_call_params ',' id
							| func_call_params ',' string 
							| string
							;
initializer					: assignment_expression {$<val>$ = $<val>1;}
							| OPEN_SCOPE initializer_list CLOSE_SCOPE
							| OPEN_SCOPE initializer_list ',' CLOSE_SCOPE
							;
initializer_list			: initializer
							| initializer_list ',' initializer
							;
type_name					: spec_qualifier_list abstract_declarator
							| spec_qualifier_list
							;
abstract_declarator			: direct_abstract_declarator
							;
direct_abstract_declarator	: '(' abstract_declarator ')'
							| direct_abstract_declarator '[' const_expression ']'
							| '[' const_expression ']' 
							| direct_abstract_declarator '[' ']'
							| '[' ']'
							| direct_abstract_declarator '(' param_type_list ')'
							| '(' param_type_list ')'
							| direct_abstract_declarator '(' ')'
							| '(' ')'
							;
stat						: labeled_stat 									      	
							| exp_stat 											  	
							| compound_stat
							| selection_stat  									  
							| iteration_stat
							| jump_stat
							;
labeled_stat				: CASE const_expression ':' stat
							| DEFAULT ':' stat
							;
exp_stat					: expression ';'
							| ';'
							;
compound_stat				: OPEN_SCOPE lists CLOSE_SCOPE
							| OPEN_SCOPE CLOSE_SCOPE
							;
lists						: decl lists
							| stat lists
							| decl
							| stat
							;
selection_stat				: SWITCH {enc_lno[scope] = lno;scope++;}'(' expression ')' compound_stat{scope--;} 							;
iteration_stat				: DO {scope++;}stat{scope--;} WHILE '(' expression ')' ';' stat
							;
jump_stat					: CONTINUE ';'
							| BREAK ';'
							| RETURN expression ';'
							| RETURN ';'
							;
expression					: assignment_expression {$<val>$ = $<val>1;}
							| expression ',' assignment_expression
							;
assignment_expression		: conditional_expression {$<val>$ = $<val>1;}
							| unary_expression '=' assignment_expression 
							{
								//printf("\nInitialization %s =%d\n\n", name, $<val>3);
								int k = search((char*)name, dectype, scope, enc_lno[scope], 0); 
								char val[100];
								sprintf(val, "%d", $<val>3);
								if(k==-1)
									s[no_of_entries++] = init_node((char*)name,scope,lno,dectype, enc_lno[scope],val);
								else if(k==-2){
									printf("Error at line number : %d\n", lno);
									printf("Aborting...\n");
									exit(0);
								}
								else
									update(k, val);
								//printf("hereeee");

							}
							;
conditional_expression		: logical_or_expression {$<val>$ = $<val>1;}
							| logical_or_expression '?' expression ':' conditional_expression
							{
								if($<val>1){
									$<val>$ = $<val>3;
								}
								else{
									$<val>$ = $<val>5;
								}
							}
							;	
const_expression			: conditional_expression {$<val>$ = $<val>1;}
							;
logical_or_expression		: logical_and_expression {$<val>$ = $<val>1;}
							| logical_or_expression OR_CONST logical_and_expression
							{
								$<val>$ = $<val>1 || $<val>3;
							}
							;
logical_and_expression		: inclusive_or_expression {$<val>$ = $<val>1;}
							| logical_and_expression AND_CONST inclusive_or_expression
							{
								$<val>$ = $<val>1 && $<val>3;
							}
							;
inclusive_or_expression		: exclusive_or_expression {$<val>$ = $<val>1;}
							| inclusive_or_expression '|' exclusive_or_expression
							{
								$<val>$ = $<val>1 | $<val>3;
							}
							;
exclusive_or_expression		: and_expression {$<val>$ = $<val>1;}
							| exclusive_or_expression '^' and_expression
							{
								$<val>$ = $<val>1 ^ $<val>3;
							}
							;
and_expression				: equality_expression {$<val>$ = $<val>1;}
							| and_expression '&' equality_expression
							{
								$<val>$ = $<val>1 & $<val>3;
							}
							;
equality_expression			: relational_expression {$<val>$ = $<val>1;}
							| equality_expression E_CONST relational_expression
							{
								$<val>$ = ($<val>1==$<val>3);
							}
							| equality_expression LE_CONST relational_expression
							{
								$<val>$ = ($<val>1<=$<val>3);
							}
							| equality_expression GE_CONST relational_expression
							{
								$<val>$ = ($<val>1>=$<val>3);
							}
							| equality_expression NE_CONST relational_expression
							{
								$<val>$ = ($<val>1!=$<val>3);
							}
							;
relational_expression		: shift_expression {$<val>$ = $<val>1;}
							| relational_expression L_CONST shift_expression
							{
								$<val>$ = ($<val>1 < $<val>3);
							}
							| relational_expression G_CONST shift_expression
							{
								$<val>$ = ($<val>1 > $<val>3);
							}
							;
shift_expression			: additive_expression {$<val>$ = $<val>1;}
							| shift_expression LSHIFT_CONST additive_expression
							{
								$<val>$ = ($<val>1 << $<val>3);
							}
							| shift_expression RSHIFT_CONST additive_expression
							{
								$<val>$ = ($<val>1 >> $<val>3);
							}
							;
additive_expression			: mult_expression {$<val>$ = $<val>1;}
							| additive_expression '+' mult_expression
							{
								$<val>$ = $<val>1 + $<val>3;
							}
							| additive_expression '-' mult_expression
							{
								$<val>$ = $<val>1 - $<val>3;
							}
							;
mult_expression				: cast_expression {$<val>$ = $<val>1;}
							| mult_expression '*' cast_expression
							{
								$<val>$ = $<val>1 * $<val>3;
							}
							| mult_expression '/' cast_expression
							{
								$<val>$ = $<val>1 / $<val>3;
							}
							| mult_expression '%' cast_expression
							{
								$<val>$ = $<val>1 % $<val>3;
							}
							;
cast_expression				: unary_expression {$<val>$ = $<val>1;}
							| '(' type_name ')' cast_expression
							;
unary_expression			: postfix_expression {$<val>$ = $<val>1;}
							| INC_CONST unary_expression
							| unary_operator cast_expression
							;
unary_operator				: '&' | '*' | '+' | '-' | '~' | '!' 			
							;
postfix_expression			: primary_expression {$<val>$ = $<val>1;}
							| postfix_expression '[' expression ']'
							| postfix_expression '(' argument_exp_list ')'
							| postfix_expression '(' ')'
							| postfix_expression INC_CONST {$<val>$ = $<val>1+1;}
							;
primary_expression			: id 
							{
								strcpy(name, idname);
								strcpy(dectype, "int");
								int k = search((char*)name, dectype, scope, enc_lno[scope], 0); 
								if(k==-1 && strcmp(name, "printf")!=0){
									printf("*******ERROR*******\n");
									printf("There's no variable by the id : %s of the type %s\n", name, dectype);
									printf("Aborting...\n");
									exit(0);
								}
								else if(strcmp(name, "printf")!=0){
									//printf("Got value of id : %s as %d", s[k].variable_name, atoi(s[k].value_of_variables));
									$<val>$ = atoi(s[k].value_of_variables);
								}								
							}										
							| consts {$<val>$ = $<val>1;}				
							| '(' expression ')' {$<val>$ = $<val>2;}
							;
argument_exp_list			: assignment_expression
							| argument_exp_list ',' assignment_expression
							;
consts						: INT
							{
								//printf("%d - %d \n", $<val>$, $1);
							}
							| CHAR  
							{
								//printf(".cval = %c\n\n", $<cval>$);
							}
							| FLOAT 
							{
								//printf(".fval = %f", $<fval>$);
							}
							;
%%
#include "lex.yy.c"
#include<ctype.h>
char st[100][10];
int top=0;
char i_[2]="0";
char temp[2]="t";


int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	if(!yyparse()){
		printf("\nParsing complete\n");
                printTable();
        }
	else
		printf("\nParsing failed\n");

	
    printf("\n");
    fclose(yyin);
    return 0;
}

int yyerror(const char *msg)
{
	extern int lno;Initialization;
	printf("Parsing Failed\nLine Number: %d %s\n",lno,msg);
	success = 0;
	return 0;
}
