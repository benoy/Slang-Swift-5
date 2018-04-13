#SLANG FOR SWIFT-4

###STATEMENT 

* **Expression is what you evaluate for it's value** 

The above two maxims can be converted into a computational structure as follows 

A) Expression is what you evaluate for its value 

```Swift
public class Expression {

B) Expression is what you evaluate for its value 

```Swift
public  class Statement{
Let us implement a Print statement for the “SLANG For Swift4” compiler. The basic idea is as follows you add a class to model a statement and since the class has to inherit from the “Statement” (abstract class), it ought to implement Execute Method. 

```Swift
public class PrintStatement:Statement{
Let us add a “PrintLine” statement as well. “PrintLine” implementation is not different from Print statement. The only difference is it emits a new line after the expression value. 

```Swift
public class PrintLineStatement:Statement{
Once we have created to classes to implement Print and “PrintLine” statement, we need to modify our parser (frontend) to support the statement in the language. 

We are going to add few more tokens to support the Statements in the SLANG. 

```Swift
public enum Token{
```

In the “Lexer”, we add a new data structure to be used for Keyword lookup. 

```Swift
public struct ValueTable{

In the Lexer class, we will populate an array of ValueTables with Token and it's textual representation as given below. 

```Swift
private var valueTables = [ValueTable( .print,"PRINT"),ValueTable(.println,"PRINTLINE") ]
```
In the Lexer class, getToken function has to be modified as follows 

```Swift
public func getToken() throws ->Token{
We need to add a new entry point into the RDParser class to support statements. The grammar for the SLANG at this point of time (to support statement) is as given below

	<stmtlist> := { statement }+ 	{statement} := <printstmt> | <printlinestmt> 

The new entry point to the parser is as follows... 

```Swift
public func parse()->[Statement]{
The getStatementList method implements the grammar given above. The BNF to source code translation is very easy and without much explanation it is given below 

	<stmtlist> := { <statement> }+ 

```Swifr
private func getStatementList()->[Statement]{
```
The method getStatement queries the statement type and parses the rest of the statement

```Swift
private func getStatement() throws ->Statement?{
Finally I have invoked these routines to demonstrate how everything is put together. 

```Swift
import Foundation

[<= Chapter-2](../../Step-2/Chapter-2/Chapter-2.md)___________________________________[Chapter-4 =>](../../Step-4/Chapter-4/Chapter-4.md)