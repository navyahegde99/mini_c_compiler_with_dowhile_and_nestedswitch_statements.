#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct node init_node(char *variable,int local_scope ,int line_no,char *type, int enclosing_line_no, char* value);
int search(char *variable,char *type, int local_scope, int enclosing_line_no, int type_dec);
void update(int k, char *value);
void printTable();

struct node
{
    char *variable_name;
    int scope_of_variable;
    int line_no;
    char *type;
    int enclosing_line_no;
    char *value_of_variables;
} s[100];


extern int no_of_entries;
