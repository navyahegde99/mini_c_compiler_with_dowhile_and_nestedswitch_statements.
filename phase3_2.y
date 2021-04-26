
%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include <stdarg.h>
void yyerror(const char*);
int yylex();
int scope[100];
int scope_ctr;
int scope_ind;
char typ[10]="nothing";
typedef struct AST{
	char lexeme[100];
	int NumChild;
	struct AST **child;
}AST_node;

struct AST* make_for_node(char* root, AST_node* child1, AST_node* child2, AST_node* child3, AST_node* child4);
struct AST * make_node(char*, AST_node*, AST_node*);
struct AST* make_leaf(char* root);
void AST_print(struct AST *t);
extern FILE* yyin;
extern int yylineno;
%}

%token DOT SINGLE SC  COMMA LETTER  OPBRACE CLBRACE CONTINUE BREAK IF ELSE FOR WHILE POW OPEN CLOSE COMMENT 

%union {char* var_type; char* text; struct AST *node;}

%token <var_type> INT FLOAT CHAR 
%token <text> ID NUM PLUS MINUS MULT DIV AND OR LESS GREAT LESEQ GRTEQ NOTEQ EQEQ ASSIGN SPLUS SMINUS SMULT SDIV INC DEC SWITCH
%token <node> MAIN RETURN DEFAULT CASE COLON

%type <var_type> Type
%type <text> Varlist relOp logOp s_op

%type <node> F T E assign_expr1 assign_expr relexp logexp cond decl unary_expr iter_stat stat comp_stat start jump_stat select_stat ST C B D s_operation 


%% 

start:INT MAIN OPEN CLOSE comp_stat  {$$ = make_leaf($1); $$=make_node("Main",$1,$5);printf("\n\nAST:\n\n"); AST_print($$);YYACCEPT;}															   
     ;

comp_stat: OPBRACE SCOPE stat CLBRACE {$$=$3;}
		 ;
		 
SCOPE: {scope_ctr++;scope[scope_ind++]=scope_ctr;}
	 ;
stat:E SC stat               {$$=make_node("Stat",$1,$3);}
    |assign_expr stat        {$$=make_node("Stat",$1,$2);}
    |comp_stat stat          {$$=make_node("Stat",$1,$2);}
    |select_stat stat        {$$=make_node("Stat",$1,$2);}
    |iter_stat stat          {$$=make_node("Stat",$1,$2);}
    |jump_stat stat     {$$=make_node("Stat",$1,$2);}
    |decl stat    {$$=make_node("Stat",$1,$2);}
    |				{$$=make_leaf("  ");}
    ;


ST  : SWITCH OPEN ID CLOSE OPBRACE B CLBRACE {$3=make_leaf($3);$$=make_node("Switch",$3,$6);}
    ; 

    
B   : C         {$$=$1;}
    | C D        {$$=make_node("Cases",$1,$2);}
    | C B       {$$=make_node("Cases",$1,$2);}
    ;
    
C   : CASE NUM COLON stat      {$$=make_node("Case",$2,$4);}
    ;

D   : DEFAULT COLON stat       {$1=make_leaf(" "); $$=make_node("Default",$1,$3);}
    ;





select_stat: ST   {$$=$1;}
		   ;

iter_stat:FOR OPEN decl cond SC E CLOSE comp_stat		{$$=make_for_node("for",$3,$4,$6,$8);}
		 ;

jump_stat:CONTINUE SC    {$$=make_leaf("Continue");}
		 | BREAK SC      {$$=make_leaf("Break");}
		 |RETURN E SC    {$1=make_leaf("Return");$$ = make_node("Stat",$1,$2);}
		 ;		

cond:relexp    {$$ = $1;}
	|logexp    {$$ = $1;}
	|E        {$$ = $1;}
	;


relexp:E relOp E   {$$=make_node($2,$1,$3);}
	  ;

logexp:E logOp E   {$$=make_node($2,$1,$3);}
	  ;

logOp:AND    {$$ = $1;}
	 |OR    {$$ = $1;}
	 ;

relOp:LESEQ   {$$ = $1;}
     |GRTEQ   {$$ = $1;}
     |NOTEQ   {$$ = $1;}
     |EQEQ   {$$ = $1;}
	 |LESS    {$$ = $1;}
	 |GREAT    {$$ = $1;}
	 ;

decl:Type Varlist SC    {$1=make_leaf($1); $$=make_leaf($2); $$=make_node("VarDecl",$1,$2); }     
    |Type assign_expr1   {$1=make_leaf($1); $$=make_node("VarDecl",$1,$2);} 
    ;
 
Type:INT 		{$$ = $1;strcpy(typ,$1);}
	|FLOAT      {$$ = $1;strcpy(typ,$1);}
	;

Varlist:Varlist COMMA ID    {$3=make_leaf($3);$$=make_node("VarList",$1,$3);} 
	   |ID 			{$$=make_leaf($1);}
	   

assign_expr:ID ASSIGN E COMMA assign_expr     {$1=make_leaf($1); $$=make_for_node($2,$1,$3,make_leaf(","),$5);}
		   |ID ASSIGN E SC            {$1=make_leaf($1); $$=make_node($2,$1,$3);} 											
		   ;

assign_expr1:ID ASSIGN E COMMA assign_expr1    {$1=make_leaf($1);$$=make_for_node($2,$1,$3,make_leaf(","),$5);}
		   |ID ASSIGN E SC           {$1=make_leaf($1);$$=make_node($2,$1,$3);}
		   ;

E:E PLUS T    {$$=make_node($2,$1,$3); }
 |E MINUS T    {$$=make_node($2,$1,$3);}
 |T            {$$=$1;}
 ;
 
T:T MULT F    {$$=make_node($2,$1,$3);}
 |T DIV F     {$$=make_node($2,$1,$3);}
 |F           {$$=$1;}
 ;
 
F:ID  {$$=make_leaf($1);}
 |NUM            {$$=make_leaf($1);}
 |OPEN E CLOSE   {$$=$2;}
 |unary_expr        {$$=$1;}
 |s_operation      {$$=$1;}
 ;
 
s_operation: ID s_op ID  {$1=make_leaf($1); $3=make_leaf($3); $$=make_node($2,$1,$3);}
			   | ID s_op NUM {$1=make_leaf($1); $3=make_leaf($3); $$=make_node($2,$1,$3);}
			   | ID s_op OPEN E CLOSE {$1=make_leaf($1); $$=make_node($2,$1,$4);}
			   ;

s_op:SPLUS   {$$=$1;}
	|SMINUS   {$$=$1;}
	|SMULT   {$$=$1;}
	|SDIV    {$$=$1;}
	;

unary_expr:INC ID {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",$1,$2);}
		  |ID INC {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",$1,$2);}
		  |DEC ID {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",$1,$2);}
		  |ID DEC {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",$1,$2);}
		  | MINUS ID {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",$1,$2);}
		  | MINUS NUM   {$$=make_leaf($1); $$=make_leaf($2);$$=make_node("temp",$1,$2);}
		  ;
%%
void yyerror(const char* arg)
{
	printf("%s\n",arg);
}


void AST_print(struct AST *t)
{
	static int ctr=0;
	//printf("inside print tree\n");
	int i;
	if(t->NumChild==0) 
		return;

	struct AST *t2=t;
	printf("\n%s  -->",t2->lexeme);
	for(i=0;i<t2->NumChild;++i) 
	{
		printf("%s ",t2->child[i]->lexeme);
	}
	for(i=0;i<t2->NumChild;++i)
	{
		AST_print(t->child[i]);
	}

	
}

struct AST* make_node(char* root, AST_node* child1, AST_node* child2)
{
	//printf("Creating new node\n");
	struct AST * node = (struct AST*)malloc(sizeof(struct AST));
	node->child = (struct AST**)malloc(2*sizeof(struct AST *));
	node->NumChild = 2;//
	strcpy(node->lexeme,root);
	//printf("Copied lexeme\n");
	//printf("%s\n",node->lexeme);
	node->child[0] = child1;
	node->child[1] = child2;
	return node;
}

struct AST* make_for_node(char* root, AST_node* child1, AST_node* child2, AST_node* child3, AST_node* child4)
{
	//printf("Creating new node\n");
	struct AST * node = (struct AST*)malloc(sizeof(struct AST));
	node->child = (struct AST**)malloc(4*sizeof(struct AST *));
	node->NumChild = 4;
	strcpy(node->lexeme,root);
	node->child[0] = child1;
	node->child[1] = child2;
	node->child[2] = child3;
	node->child[3] = child4;
	return node;
}


struct AST* make_leaf(char* root)
{
	//printf("Creating new leaf ");
	struct AST * node = (struct AST*)malloc(sizeof(struct AST));
	strcpy(node->lexeme,root);
	//printf("%s\n",node->lexeme);
	node->NumChild = 0;
	node->child = NULL;
	return node;
}



int main(int argc,char **argv)
{
	yyin=fopen(argv[1],"r");
	if(!yyparse())
	{
		printf("Success\n");

	}
	else
	{
		printf("Fail\n");
	}

	return 0;
}


