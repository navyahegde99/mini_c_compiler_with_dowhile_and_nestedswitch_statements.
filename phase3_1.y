%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define COUNT 10
int curr_scope = 0;
int insideloop = 0;
int opening_brackets = 0;
int closing_brackets = 0;
int nesting = 0;

typedef struct Node{
	struct Node *left;
	struct Node *right;
	char token[100];
	struct Node *val;
}Node;

typedef struct tree_stack{
	Node *node;
	struct tree_stack *next;
}tree_stack;

typedef struct Trunk
{
	struct Trunk *prev;
	char str[100];
}Trunk;


void push_scope(int);
void pop_scope();
int peep_scope();
void create_node(char *token, int leaf);
void push_tree(Node *newnode);
Node* pop_tree();
Node* pop_tree_2();
void printtree(Node *tree);
void printTree(Node* root, Trunk*,int);
void showTrunks(Trunk *p);

extern char yytext[];
extern int line_number;
extern int column;
extern FILE *yyin;

//Global variables
tree_stack *tree_top = NULL;
%}

%union
{
	int ival;
	char string[128];
}

%token IDENTIFIER CONSTANT CHAR_CONSTANT INT_CONSTANT FLOAT_CONSTANT STRING_LITERAL SIZEOF
%token INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP H
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token CHAR SHORT INT LONG FLOAT DOUBLE VOID

%token IF ELSE WHILE DO CONTINUE BREAK RETURN
%token HASH INCLUDE LIBRARY

%type <string> IDENTIFIER CONSTANT CHAR_CONSTANT FLOAT_CONSTANT INT_CONSTANT STRING_LITERAL SIZEOF INC_OP DEC_OP LE_OP GE_OP EQ_OP NE_OP H AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN CHAR SHORT INT LONG FLOAT DOUBLE VOID
%type <string>  IF ELSE  CONTINUE BREAK RETURN HASH INCLUDE LIBRARY 
%type <string> declaration init_declarator_list init_declarator type_specifier declarator logical_and_expression logical_or_expression conditional_expression assignment_expression initializer
%type <string> primary_expression postfix_expression unary_expression multiplicative_expression additive_expression relational_expression equality_expression expression initializer_list

%start hashinclude
%%

primary_expression
	: IDENTIFIER	{ strcpy($$, $1); create_node($1, 1);}
    | CHAR_CONSTANT		{ strcpy($$, $1); create_node($1, 1);}
	| FLOAT_CONSTANT	{ strcpy($$, $1); create_node($1, 1);}
    | CONSTANT          { strcpy($$, $1); create_node($1, 1);}
    | INT_CONSTANT		{ strcpy($$, $1); create_node($1, 1);}
	| STRING_LITERAL	{ strcpy($$, $1); create_node($1, 1);}
	| '(' expression ')'	{}
	;

postfix_expression
	: primary_expression	{ strcpy($$, $1); }
	| postfix_expression '[' expression ']'	{
												pop_tree();
												pop_tree();
												char s[30];
												strcpy(s, $1);
												strcat(s, "[");
												strcat(s, $3);
												strcat(s, "]");
												create_node(s, 1);
												strcpy($$, s);

											}
	| postfix_expression '(' ')'	{}
	| postfix_expression '(' argument_expression_list ')'	{}
	| postfix_expression '.' IDENTIFIER		{}
	| postfix_expression INC_OP		{

		create_node("1",1);
		create_node("+", 0);

	}
	| postfix_expression DEC_OP		{

		create_node("1",1);
		create_node("-", 0);

	}
	;

argument_expression_list
	: assignment_expression		{}
	| argument_expression_list ',' assignment_expression	{}
	;

unary_expression
	: postfix_expression	{ strcpy($$, $1); }
	| INC_OP unary_expression	{

		create_node("1",1);
		create_node("+", 0);

	}
	| DEC_OP unary_expression	{

		create_node("1",1);
		create_node("-", 0);

	}
	| unary_operator unary_expression	{}
	| SIZEOF unary_expression	{}
	| SIZEOF '(' type_specifier ')'	{}
	;

unary_operator
	: '&'	{}
	| '*'	{}
	| '+'	{}
	| '-'	{}
	| '~'	{}
	| '!'	{}
	;

multiplicative_expression
	: unary_expression	{ strcpy($$, $1); }
	| multiplicative_expression '*' unary_expression	{
															create_node("*", 0);
														}
	| multiplicative_expression '/' unary_expression	{
															create_node("/", 0);

														}
	| multiplicative_expression '%' unary_expression	{
															create_node("%", 0);

														}
	;

additive_expression
	: multiplicative_expression	{ strcpy($$, $1); }
	| additive_expression '+' multiplicative_expression		{
															create_node("+", 0);
														}
	| additive_expression '-' multiplicative_expression		{
															create_node("-", 0);
														}
	;

relational_expression
	: additive_expression	{ strcpy($$, $1); }
	| relational_expression '<' additive_expression		{

															create_node("<", 0);

														}
	| relational_expression '>' additive_expression		{
															create_node(">", 0);

														}
	| relational_expression LE_OP additive_expression	{
															create_node("<=", 0);

														}
	| relational_expression GE_OP additive_expression	{
															create_node(">=", 0);
															
														}
	;

equality_expression
	: relational_expression	{ strcpy($$, $1); }
	| equality_expression EQ_OP relational_expression	{
															create_node("==", 0);
															
														}
	| equality_expression NE_OP relational_expression	{
															create_node("!=", 0);
														
														}
	;

logical_and_expression
	: equality_expression	{ strcpy($$, $1); }
	| logical_and_expression AND_OP equality_expression		{
																create_node("&&", 0);

															}
	;

logical_or_expression
	: logical_and_expression	{ strcpy($$, $1); }
	| logical_or_expression OR_OP logical_and_expression	{create_node("||", 0);}
	;

conditional_expression
	: logical_or_expression	{ strcpy($$, $1); }
	| logical_or_expression '?' expression ':' conditional_expression	{}
	;

assignment_expression
	: conditional_expression	{ strcpy($$, $1); }
	| unary_expression assignment_operator assignment_expression	{
																		//addval($1, $3, curr_scope);
																		create_node("=", 0);
																	}
	;

assignment_operator
	: '='	{}
	| MUL_ASSIGN	{}
	| DIV_ASSIGN	{}
	| MOD_ASSIGN	{}
	| ADD_ASSIGN	{}
	| SUB_ASSIGN	{}

	;

expression
	: assignment_expression	{ strcpy($$, $1); }
	| expression ',' assignment_expression	{}
	;




parameter_list
	: parameter_declaration	{}
	| parameter_list ',' parameter_declaration	{}
	;

parameter_declaration
	: type_specifier declarator		{}//{	lookup($1, $2);		}
	| type_specifier	{}
	;

identifier_list
	: IDENTIFIER	{
	
	}
	| identifier_list ',' IDENTIFIER	{}
	;


initializer
	: assignment_expression	{ strcpy($$, $1); }
	| '{' initializer_list '}'	{
									char s[20] = "{";
									strcat(s, $2);
									strcat(s, "}");
									strcpy($$, s);
									for(int i=0; s[i]!='}'; i++)
									{
										Node *n;
										if(s[i]==',')
											n=pop_tree();
									}
									pop_tree();
									create_node(s, 1);
								}
	| '{' initializer_list ',' '}'	{
										char s[20] = "{";
										strcat(s, $2);
										strcat(s, ",}");
										strcpy($$, s);
										create_node(s, 1);
									}
	;

initializer_list
	: initializer	{ strcpy($$, $1);}
	| initializer_list ',' initializer	{}
	;

statement //HERE YOU MADE CHANGE
	: compound_statement
	| expression_statement	{}
	| selection_statement	{}
	| iteration_statement {}
	| jump_statement		{}
    | declaration     {}
	;


compound_statement
	: compound_statement_types
	;

compound_statement_types
	: '{' '}'
	| '{' statement_list '}'
	;

declaration
	: type_specifier init_declarator_list ';'	{
								// printf("%s %s", $1, $2);

							}
	;

init_declarator_list
	: init_declarator		{strcpy($$,$1);}
	| init_declarator_list ',' init_declarator		{
														strcpy($$,$3);
														strcat($$, ",");
														strcat($$, $1);
													}
	;

init_declarator
	: declarator 	{strcpy($$,$1);}
	| declarator '=' initializer	{
										create_node("=", 0);
										char val[20];
										strcpy(val, $3);
										}
									
	;

type_specifier
	: VOID		{strcpy($$,$1);}
	| CHAR		{}
	| SHORT		{}
	| INT		{strcpy($$,$1);}
	| LONG		{}
	| FLOAT		{}
	| DOUBLE	{}
	;

declarator
	: IDENTIFIER            { create_node($1, 1); strcpy($$,$1);}
	/* | '(' declarator ')' */
	| declarator '[' INT_CONSTANT ']' {
										Node * n= pop_tree();
										char s[30] = "";
										strcat(s, $1);
										strcat(s,"[");
										strcat(s, $3);
										strcat(s, "]");
										create_node(s, 1);
										}
	| declarator '(' parameter_list ')'	{}
	| declarator '(' identifier_list ')'	{}
	| declarator '(' ')'	{strcpy($$, $1); }
	;

statement_list
	: statement	{}
	| statement_list statement	{ create_node("stmt", 0);}
	;

expression_statement
	: ';'	{}
	| expression ';'	{}
	;

selection_statement
	: IF '(' expression ')' compound_statement { create_node("if", 0);}
	| IF '(' expression ')' compound_statement ELSE compound_statement{create_node("else", 0); create_node("if", 0);}
	;

iteration_statement
	: WHILE '(' expression ')' {insideloop = 1; } compound_statement { insideloop = 0; create_node("while", 0);}
	| DO  {insideloop = 1; }  compound_statement WHILE '(' expression ')' ';' {insideloop = 0; create_node("do-while", 0);}
	;


jump_statement
	: CONTINUE ';'	{}
	| BREAK ';'		{
						if(!insideloop)
						{
							printf("\n%*s\n%*s   <--- break statement not within loop \n", column, "^", column);
							exit(0);
						}
					}
	| RETURN ';'	{ create_node("return",1);}
	| RETURN expression ';'	{ char s[20] = "return ";strcat(s, $2);}
							 
	;

hashinclude
	: HASH INCLUDE '<' IDENTIFIER '.' H '>' hashinclude	{}
	| translation_unit {} //{display(st);}
	;

translation_unit
	: external_declaration	{}
	| translation_unit external_declaration	{}
	;

external_declaration
	: function_definition	{}
	| declaration	{}
	;

function_definition
	: type_specifier declarator compound_statement	{}	{}
	| declarator declaration compound_statement {}
	| declarator compound_statement	{}
	;

%%

void create_node(char *token, int leaf)
{
	Node *l;
	Node *r;
	if(leaf==0)
	{
		r = pop_tree();
		l = pop_tree();
	}
	else if(leaf ==1)
	{
		l = NULL;
		r = NULL;
	}
	else
	{
		l = pop_tree();
		r = NULL;
	}
	Node *newnode = (Node*)malloc(sizeof(Node));
	strcpy(newnode->token, token);
	newnode->left = l;
	newnode->right = r;
	push_tree(newnode);
}
void push_tree(Node *newnode)
{
	tree_stack *temp= (tree_stack*)malloc(sizeof(tree_stack));
	temp->node = newnode;
	temp->next = tree_top;
	tree_top = temp;
}
void modify_top(char *s)
{
	strcpy(tree_top->node->token, s);
}

Node* pop_tree()
{
	if(tree_top==NULL)
		return NULL;
	tree_stack *temp = tree_top;
	tree_top = tree_top->next;
	Node *retnode = temp->node;
	free(temp);
	return retnode;
}
Node* pop_tree_2()
{
	if(tree_top==NULL)
		return NULL;
	tree_stack *temp = tree_top->next;
	tree_top->next = tree_top->next->next;
	Node *retnode = temp->node;
	free(temp);
	return retnode;
}
// Helper function to print branches of the binary tree
void showTrunks(Trunk *p)
{
	if (p == NULL)
		return;

	showTrunks(p->prev);

	printf("%s",p->str);
}

// Recursive function to print binary tree
// It uses inorder traversal
void printTree(Node *root, Trunk *prev, int isLeft)
{
	if (root == NULL)
		return;

	char prev_str[100] = "	  ";
	Trunk *trunk = (Trunk*)malloc(sizeof(Trunk));
	trunk->prev = prev;
	strcpy(trunk->str, prev_str);

	printTree(root->right, trunk, 1);

	if (!prev) //if prev == NULL
		strcpy(trunk->str,"---");
	else if (isLeft)
	{
		strcpy(trunk->str,".---");
		strcpy(prev_str,"\t  |");
	}
	else
	{
		strcpy(trunk->str,"`---");
		strcpy(prev->str,prev_str);
	}

	showTrunks(trunk);
	printf(" %s\n",root->token);
	if (prev)
		strcpy(prev->str,prev_str);
	strcpy(trunk->str,"\t  |");

	printTree(root->left, trunk, 0);
}

void printtree(Node *tree)
{
	int i;
	if (tree->left || tree->right)
 		printf("(");
	printf(" %s ", tree->token);
	if (tree->left)
		printtree(tree->left);
	if (tree->right)
		printtree(tree->right);
	if (tree->left || tree->right)
		printf(")");
}

yyerror(s)
char *s;
{
	fflush(stdout);

		printf("\n%*s\n%*s\n", column, "^", column, s);


}

int main(int argc,char **argv)
{
	yyin = fopen(argv[1], "r");
	tree_top = (tree_stack*)malloc(sizeof(tree_stack));
	tree_top->node = NULL;
	tree_top->next = NULL;
	struct Node *root;
	yyparse();
	root = pop_tree();

	printtree(root);
	printf("\n");
	printTree(root, NULL, 0);
	fclose(yyin);

}

