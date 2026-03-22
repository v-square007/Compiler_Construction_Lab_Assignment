# Compiler_Construction_Assignment
This repository contains the multi-phase implementation of a compiler developed for the CS F363: Compiler construction course. The project demonstrates the transition from raw source code to a structured, validated syntactic representation.

___Note: This repository is being constantly updated as I progress through the subsequent stages of compiler construction.___  


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

### Question 1: Lexical Specification and Tokenization (5 Marks)
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

### Question 2: Grammar Design and Syntactic Validation (7 Marks)
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

### Question 3: Syntax Error Detection (3 Marks)
Demonstrate that your syntax analyzer can detect and report syntactic errors. Introduce at least
two intentional syntax errors into the evaluation program and show the corresponding error
messages produced by your system.

### How to run
```lex
#compile the lexer
lex Q1.l
gcc lex.yy.c -ll -o lexer

#compiler using Bison for verbose error support
bison -d Q3.y
gcc Q3.tab.c -o parser_v2
#Run the pipeline
./lexer < code.txt | ./parser_v2
```

### Question 4: Symbol Table and Scope Handling (5 Marks)
Design and implement a symbol table capable of:  
• Storing variable name, type, scope, and memory offset  
• Supporting insertion and lookup  
• Handling nested block scopes  
Demonstrate symbol table updates while processing the evaluation program.

### How to run
