#SLANG FOR SWIFT-4

###Types, Variables and Assignment Statement 

The language supports only three data types

NUMERIC 



Let us add an enum for data types 

```Swift
public enum TypeInfo{
```
Every variable will have a name, type and a slot for storing its value in the symbol table. Moreover, Functions return SymbolInfo. 

```Swift
public struct SymbolInfo{
The next step is to modify the Expression and Statement classes to reflect the variable support. 

```Swift
public class Expression {
```

The class RunTime context contains the Symbol Table during interpretation. 

```Swift
public class RuntimeContext {

Let us write the code for BooleanConstant node. This will store TRUE or FALSE value. 

```Swift
public class BooleanConstant:Expression{
The next thing, which we should support, is NumericConstant. This will store a IEEE 754 double precision floating point value. 

```Swift
public class NumericConstant:Expression{

The AST node for storing String Literal is as given below 

```Swift
public class StringLitteral:Expression{
Adding support to variable is an involved activity. 

```Swift
public class Variable:Expression{
At this point of time Expression hierarchy ( without operators ) looks like as follows 

The first operator to be supported is Binary + 

```Swift
public class BinaryPlus:Expression{
Where as Evaluate routine for StringLiteral, NumericConstant, BooleanConstant and Variable just involves returning the SymbolInfo, in the case of Operators things are bit evolved... 

In the above code snippet, Left and Right expressions are evaluated and the types are queried. In our compiler, operations involving numerics and strings are successful only if all the operands are of the same type. 

The routine TypeCheck is similar to Evaluate. Only difference is that TypeCheck updates the type information of the nodes in a Recursive manner. The routine getType is only valid once you have 

BinaryMinus is similar to BinaryPlus. The only difference is only Numerics can be subtracted. 

```Swift
public class BinaryMinus:Expression{
Multiplication and Division operators are only valid for Numeric Types. If you have understood the implementation of BinaryPlus , the Multiplication and Division operators are easy to follow 

**Multiplication:**

```Swift
public class Multiplication:Expression{

**Division**

```Swift
public class Division:Expression{

UnaryPlus and UnaryMinus is also similar to the implementation of other operators. Both these operators are only applicable for Numeric data type. 

```Swift
public class UnaryPlus:Expression{

The statement related nodes are moved to a separate module by the name AstForStatements. In this step, we have added support for Variable Declaration and Assignment statement. The AST for Variable declaration is given below

```Swift
public class VariableDeclStatement:Statement{
In the parser, before we create ‘VariableDeclStatement’ node, we need to insert the variable's SYMBOL_INFO into the ‘SymbolTable’ of the ‘CompilationCOntext’.

The AST for Assignment statement is given below 
public class AssignmentStatement:Statement{

At this point of time , AST for Statements is as shown below 




```Swift
public class SymbolInfo{

The class CsyntaxErrorLog and CsemanticErrorLog ( in SlangError.swift) is meant for error logging while the compilation process is going on..... 

Let us go back to Lexical Analysis stage once again. This time we have added lot of new keywords to the language and Token set has become bit larger than the previous step. 

```Swift
public enum Token{
We have also moved couple of routines and state variables to ‘Lexer’ class. The two notable additions are 

```Swift
    var currentToken:Token = .illegal

Since we have added support for string type, we need to support string literals ( or the last grabbed string ) in the lexical analyzer.

```Swift
	var lastStr:String = ""
```	
	
	We need to update the keyword table with additional key words supported by the compiler 
	
```Swift
private var keyWords = [

The Parsing of the statements starts from parse Routine of RDParser.cs 

```Swift
public func parse(_ icContext:CompilationContext?)->[Statement]{

Any variable encountered during the parse process will be put into the symbol table associated with Compilation Context. 

The Logic of the getStatementList is as follows, while there are more statements, parse and add Statements to the array 

The Grammar supported is given below

	<stmtlist> := { <statement> }+ ///  

```Swift
private func getStatementList(_ icContext:CompilationContext? )->[Statement]{
The Statement method just queries the statement type and calls the appropriate Parse Routines 

```Swift
private func getStatement( _ icContext:CompilationContext? ) throws ->Statement?{
 }
The Source code of the parseVariableDeclStatement is as given below 

```Swift
func parseVariableDeclStatement(_ icContext:CompilationContext?) throws ->Statement{

Assignment statement is easy to parse as the required ground work has already been done... ! 

```Swift
private func parseAssignmentStatement(_ icContext:CompilationContext? ) throws ->Statement{

**Parsing Expressions**

The grammar for expression is given below 

Let us take a look at the Expression routine, ie the top most expression parsing routine at this point of time... (In future, when logical expressions and relational expressions are added, we modify the grammar) 

```Swift
private func getExpression( _ icContext:CompilationContext?) throws ->Expression?{
The Term routine handles the Multiplication and the Division operators 

```Swift
private func getTerm(_ icContext:CompilationContext?) throws ->Expression?{
The factor routine is where we handle Variables, unary Operations, Constants etc.. 

```Swift
private func getFactor(_ icContext:CompilationContext?) throws -> Expression?{
This is how we need to invoke the Script. 

```Swift
let path1 = "path/to/script/First.sl"
First.sl
```SLANG











```SLANG
```









![](Output1.png)


[<= Chapter-3](../../Step-3/Chapter-3/Chapter-3.md)