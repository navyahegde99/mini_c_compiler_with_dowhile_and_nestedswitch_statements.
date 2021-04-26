/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT = 258,
    CHAR = 259,
    FLOAT = 260,
    string = 261,
    id = 262,
    TYPE_CONST = 263,
    DEFINE = 264,
    OPEN_SCOPE = 265,
    CLOSE_SCOPE = 266,
    IF = 267,
    FOR = 268,
    DO = 269,
    WHILE = 270,
    BREAK = 271,
    SWITCH = 272,
    CONTINUE = 273,
    RETURN = 274,
    CASE = 275,
    DEFAULT = 276,
    GOTO = 277,
    SIZEOF = 278,
    OR_CONST = 279,
    AND_CONST = 280,
    E_CONST = 281,
    NE_CONST = 282,
    LE_CONST = 283,
    GE_CONST = 284,
    G_CONST = 285,
    L_CONST = 286,
    LSHIFT_CONST = 287,
    MUL_EQ = 288,
    DIV_EQ = 289,
    ADD_EQ = 290,
    PER_EQ = 291,
    RS_EQ = 292,
    SUB_EQ = 293,
    LS_EQ = 294,
    AND_EQ = 295,
    XOR_EQ = 296,
    OR_EQ = 297,
    RSHIFT_CONST = 298,
    REL_CONST = 299,
    INC_CONST = 300,
    DEC_CONST = 301,
    ELSE = 302,
    HEADER = 303,
    Initialization = 304
  };
#endif
/* Tokens.  */
#define INT 258
#define CHAR 259
#define FLOAT 260
#define string 261
#define id 262
#define TYPE_CONST 263
#define DEFINE 264
#define OPEN_SCOPE 265
#define CLOSE_SCOPE 266
#define IF 267
#define FOR 268
#define DO 269
#define WHILE 270
#define BREAK 271
#define SWITCH 272
#define CONTINUE 273
#define RETURN 274
#define CASE 275
#define DEFAULT 276
#define GOTO 277
#define SIZEOF 278
#define OR_CONST 279
#define AND_CONST 280
#define E_CONST 281
#define NE_CONST 282
#define LE_CONST 283
#define GE_CONST 284
#define G_CONST 285
#define L_CONST 286
#define LSHIFT_CONST 287
#define MUL_EQ 288
#define DIV_EQ 289
#define ADD_EQ 290
#define PER_EQ 291
#define RS_EQ 292
#define SUB_EQ 293
#define LS_EQ 294
#define AND_EQ 295
#define XOR_EQ 296
#define OR_EQ 297
#define RSHIFT_CONST 298
#define REL_CONST 299
#define INC_CONST 300
#define DEC_CONST 301
#define ELSE 302
#define HEADER 303
#define Initialization 304

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 35 "phase2.y" /* yacc.c:1909  */

	int val;
	float fval;
	char cval;

#line 158 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
