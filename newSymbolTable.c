#include "newSymbolTable.h"

struct node init_node(char *variable,int local_scope ,int line_no,char *type, int enclosing_line_no, char* value){
	struct node node1;
	node1.variable_name = (char*)malloc(sizeof(char)*100);
	node1.value_of_variables = (char*)malloc(sizeof(char)*100);
	node1.type = (char*)malloc(sizeof(char)*100);
	strcpy(node1.variable_name, variable);
	node1.scope_of_variable=local_scope;
	node1.line_no =line_no;
	strcpy(node1.type, type);
	node1.enclosing_line_no=enclosing_line_no;
	strcpy(node1.value_of_variables, value);
	return node1;
}

int search(char *variable, char *type, int local_scope, int enclosing_line_no, int type_dec)
{
	
	int flag1=0,flag2=0;
	int present=0;
	int k=0;
	int local_k=0;
	for (int i=0;i<no_of_entries;i++)
	{
		if(strcmp(variable,s[i].variable_name)==0)
		{
			if((local_scope==s[i].scope_of_variable) && (enclosing_line_no==s[i].enclosing_line_no))
			{
				
				flag2=1;
				local_k=i;
				present = 1;
			}
			else if(local_scope>s[i].scope_of_variable)
			{
				present = 1;
				k = i;
				flag1=s[i].scope_of_variable;
			}
			else
				;
		}
	}
	if(present==0)
		return -1;
	if(type_dec==1){
		if(flag2==1)
		{
			printf("--------ERROR--------\n");
			printf("*******Multiple declarations not allowed for the same scope*******\n");
			printf("*******Variable %s(%s) declared earlier as %s*******\n", variable, type, s[local_k].type);
			return -2;
		}
		else
		{
			if(strcmp(s[k].type, type)==0)
				return k;
			return -1;
		}
	}
	else{
		if(flag2==1){
			//printf("gdgdfgfgfdghfgh\n");
		//	printf("%s - %s\n", s[local_k].type, type);
			if(strcmp(s[local_k].type, type)==0)
				return local_k;
			return -1;
		}
		else{
			//printf("htfhjgmnvbnbfv\n");
		//	printf("%s - %s\n", s[k].type, type);
			if(strcmp(s[k].type, type)==0)
				return k;
			return -1;	
		}
	}
}

void update(int k, char *value){
	strcpy(s[k].value_of_variables, value);
	return;
}

void printTable(){
	printf("----------------------SYMBOL TABLE----------------------\n\n");
	printf("Id\t\tVal\tType\tScope\n\n");
	for(int i=0;i<no_of_entries;i++){
		printf("%s\t\t%s\t%s\t%d\n", s[i].variable_name, s[i].value_of_variables, s[i].type, s[i].scope_of_variable);
	}
}
