# Compiler_Construction_Assignment
This repository contains the multi-phase implementation of a compiler developed for the CS F363: Compiler construction course. The project demonstrates the transition from raw source code to a structured, validated syntactic representation.

## 📌 Table of Contents
* [Getting Started](#getting-started)
* [Assignment Specification](#assignment-specification)
* [The Phases of a Compiler](#the-phases-of-a-compiler)
* [Test input Code](#test-input-code)
* [Assignment Questions](#assignment-questions)
  * [Question 1: Lexical Specification and Tokenization](#question-1-lexical-specification-and-tokenization)
  * [Question 2: Grammar Design and Syntactic Validation](#question-2-grammar-design-and-syntactic-validation)
  * [Question 3: Syntax Error Detection](#question-3-syntax-error-detection)
  * [Question 4: Parser Implementation](#question-4-parser-implementation)
  * [Question 5: Symbol Table and Scope Handling](#question-5-symbol-table-and-scope-handling)
  * [Question 6: Semantic Analysis](#question-6-semantic-analysis)
  * [Question 7: Intermediate Code Generation](#question-7-intermediate-code-generation)
  * [Question 8: Optimization and Target Code Generation](#question-8-optimization-and-target-code-generation)
  
## 🏁 GETTING STARTED
To access the project files and the run the compiler phases on your local machine, clone this repository using the following command:  
```bash
git clone https://github.com/v-square007/Compiler_Construction_Lab_Assignment.git
```

 
## 📄 ASSIGNMENT SPECIFICATION
For a detailed understanding of the grammar rules, language constraints, and evaluation criteria, please refer to the official document:  
[Download assignment PDF](https://drive.google.com/file/d/1Qt1TorGm6ChUJDx0ErvBEX6OI8GSv61V/view?usp=sharing)


## ⛭ THE PHASES OF A COMPILER
A traditional compiler operates through a series of distinct phases to translate high-level code into machine executable instructions.

|  PHASE  |  NAME  |  FUNCTION  |
| :--- | :--- | :--- |
| 1 | Lexical Analysis | Scans source code to identify and categorize tokens like keywords, identifiers and constants. |
| 2 | Syntax Analysis | Groups tokens into hierarchical structures (parse trees) based on Context-Free Grammar rules. |
| 3 | Semantic Analysis | Ensures the code makes sense logically, checking for type compatibility and variable declarations. |
| 4 | Symbol Table Management | A central repository that stores information about every identifier, including its types, scope, and location. |
| 5 | Intermediate Code Generation | Produces a machine-independent intermediate representation. |
| 6 | Basic Code Optimization | Analyses and ttransforms the intermediate code to improve its performance or reduce its memory footprint. |
| 7 | Target Code Generation | Translates the optimized intermediate representation into the specific assembly or machine language of the target hardware. |


## ✉️ TEST INPUT CODE
To test the compiler, save the following sample code as "__code.txt__" in your project directory. 
```c
int a;  
int b;  
int sum;  
float avg;  
a = 2 * (3 + 4);  
b = 15;  
sum = 0;  
while (a < b && b != 0) {  
 int temp;  
 temp = a * 2;  
 if ((temp % 3 == 0) || (a > 5)) {  
 sum = sum + temp;  
 } else {  
 sum = sum - 1;  
 }  
 a = a + 1;  
}  
avg = sum / (b - a);  
if (!(avg < 5.0)) {  
 print(sum);  
} else {  
 print(avg);  
}  
```

## 📝 ASSIGNMENT QUESTIONS

### Question 1: Lexical Specification and Tokenization
Using the given language specification (int, float, control constructs, operators, etc.), formally
define the lexical structure of the language.  

You are required to:  
• Identify and classify all token categories relevant to the prescribed constructs.  
• Specify the regular expressions corresponding to each token class.  
• Implement a lexical analyzer that reads a source program and generates a token stream.  
• Demonstrate the token stream generated for the prescribed evaluation program.  
• Clearly report lexical errors, if any.  
Your lexical analyzer must correctly tokenize the entire evaluation program provided.  

### How to run
```lex
lex Q1.l
gcc lex.yy.c -ll -o lexer
./lexer < code.txt
```

### Question 2: Grammar Design and Syntactic Validation
Construct a complete Context-Free Grammar (CFG) that generates the prescribed core language,
including:  
• Declarations  
• Assignment statements  
• Expressions  
• Boolean expressions  
• if–else statements  
• while loops  
• Block structures  

The grammar must be capable of generating the entire evaluation program without modification.  
You must then demonstrate syntactic validation by:  
• Showing leftmost derivation for at least one non-trivial statement from the evaluation
program.  
• Showing rightmost derivation for at least one non-trivial statement.  
• Constructing the corresponding parse tree.  
The syntax analyzer must consume the token stream produced by your lexical analyzer.

### How to run
```lex
#compile the lexer
lex Q1.l
gcc lex.yy.c -ll -o lexer

#compiler the parser
yacc -d Q2.y
gcc y.tab.c -o parser
./lexer < code.txt | ./parser
```

### Question 3: Syntax Error Detection
Demonstrate that your syntax analyzer can detect and report syntactic errors. Introduce at least
two intentional syntax errors into the evaluation program and show the corresponding error
messages produced by your system.

### How to run
```lex
#compile the lexer
lex q1.l
gcc lex.yy.c -ll -o lexer

#compiler using Bison for verbose error support
bison -d q3.y
gcc Q3.tab.c -o parser_v2

./lexer < code.txt | ./parser_v2   #Run the pipeline
```

### Question 4: Parser Implementation
Upgrade your syntax analyzer by implementing two of the following:  
• LL(1) parser  
• Shift-Reduce parser  
• SLR/LR(0) parser  

You must provide:  
• FIRST and FOLLOW sets  
• Parsing table construction  
• Parsing stack trace for a non-trivial input  
The parser must correctly process the evaluation program.


### How to run
```lex
bison -Wno-yacc -d q4.y
lex q1.l
gcc q4.tab.c lex.yy.c ll1.c -o compiler
./compiler
```

### Question 5: Symbol Table and Scope Handling
Design and implement a symbol table capable of:
• Storing variable name, type, scope, and memory offset
• Supporting insertion and lookup
• Handling nested block scopes
Demonstrate symbol table updates while processing the evaluation program.

### Question 6: Semantic Analysis
Using the parse tree or abstract syntax tree, implement semantic analysis for the prescribed language. Your system must detect and report:
• Use of undeclared variables
• Multiple declarations within the same scope
• Type mismatches in assignment and expressions
• Invalid boolean conditions
Demonstrate semantic validation for the evaluation program and show at least two semantic error cases.

### How to run
```lex
bison -Wno-yacc -d q56.y
lex q1.l
gcc q56.tab.c lex.yy.c ll1_f.c -o compiler
./compiler code.txt
```

### Question 7: Intermediate Code Generation
Generate Three-Address Code (TAC) for the entire evaluation program. Your implementation must correctly handle:
• Arithmetic expressions
• Boolean expressions
• Conditional branching
• Loop control flow
Temporary variables and jump labels must be clearly shown.

### How to run
```lex
bison -Wno-yacc -d q7_tac.y
lex q7tac.l
gcc q7_tac.tab.c lex.yy.c ll1_tac.c -o compiler
./compiler
```

### Question 8: Optimization and Target Code Generation
Apply at least one basic optimization technique to the generated intermediate code. Then generate corresponding target code in the form of Pseudo assembly code. The generated target code must preserve program semantics.

### How to run
```lex
bison -Wno-yacc -d q8_opt.y
lex q7tac.l
gcc lab.tab.c lex.yy.c ll1_opt.c -o compiler
./compiler input.txt
```
