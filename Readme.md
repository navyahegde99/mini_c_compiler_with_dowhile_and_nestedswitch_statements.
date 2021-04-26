Section : E
Project Title : Mini C compiler for nested do-while loop and switch statements
Team Members : Meishty Pande(PES1201700224) , Sampreetha V (PES1201701542) , Nidige Shreerashmi(PES1201700196)
Project Guide :
	1.Prof. Preet Kanwal 
	2.Mr. Suhas G K
Project Abstract : We are creating the mini C compiler  where the construct nested do-while with switch statements are focussed. The six phases of the compiler are produced which are:
		1. Lexical Analysis
		2. Syntax Analysis
		3. Semantic Analysis
		4. ICG
		5. Code optimization
		6. Target Code generation

Code execution:
		1. Lexical Analysis
			lex phase1.l
			gcc lex.yy.c -ll
			./a.out input_files (Here the input_files are first, second)
		2. Syntax Analysis
			lex phase2.l
			yacc -d phase2.y
			gcc y.tab.c newSymbolTable.c -ll
			./a.out input_files (Here the input_files are first, second , third and fourth)

		3. Semantic Analysis
			->Switch 
			lex phase3_2.l
			yacc -d phase3_2.y
			gcc lex.yy.c y.tab.c -ll
			./a.out input (Here the input is first)
			->Do-While 
			lex phase3_1.l
			yacc -d phase3_1.y
			gcc lex.yy.c y.tab.c -ll
			./a.out input (Here the input is second)


		4. ICG
			->Switch 
			lex phase4_2.l
			yacc -d phase4_2.y
			gcc lex.yy.c y.tab.c -ll
			./a.out input (Here the input is first)
			->Do-While 
			lex phase4_1.l
			yacc -d phase4_1.y
			gcc lex.yy.c y.tab.c -ll
			./a.out input (Here the input is second)
		5. CO
			python3 co.py input_files(icg1.txt,icg2.txt)
		6. Target Code generation
			python3 Target.py 
		


