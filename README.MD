#SLANG FOR SWIFT-4

Difficulties in compiler development arise mainly because of human concerns: semantic correctness and following a strict standard. Those concerns are easier to satisfy when designing a new language, as the standard is usually malleable.

Thanks to the availability of information and better tools writing a compiler has become just an exercise in software engineering. The Compilers are not difficult programs to write. The various phases of compilers are easy to understand in an independent manner. The relationship is not purely sequential. It takes some time to put phases in perspective in the job of compilation of programs. 

The task of writing a compiler can be viewed in a top down fashion as follows 

Parsing => Creation of Abstract Syntax Tree => Tree Traversal to generate the Object code or Recursive interpretation. 

###Abstract Syntax Tree
In computer science, an abstract syntax tree (AST), or just syntax tree, is a tree representation of the abstract (simplified) syntactic structure of source code written in a certain programming language. Each node of the tree denotes a construct occurring in the source code. The syntax is abstract in the sense that it does not represent every detail that appears in the real syntax. For instance, grouping parentheses is implicit in the tree structure, and a syntactic construct such as “ if ‘cond’ then ‘expr’ ” may be denoted by a single node with two branches. Most of you might not be aware of the facts that, programming languages are hierarchical in nature. We can model programming language constructs as classes. Trees are a natural data structure to represent most things hierarchical. 

As a case in the point, let us look a simple expression evaluator. The expression evaluator will support double precision floating point value as the operands. The Operators supported are addition (+), subtraction (-), multiplication (*) and division. The Object model support Unary operators (+, -) as well. We are planning to use a composition model for modeling an expression. 

In most imperative programming languages, an expression is something which u evaluate for its value. Where as statements are something which you executes for it's effect. 

*Let us design a class for Expression*

```Swift
class Expression{
    
    init(){
    }
    
    func evaluate( _ iContext:RuntimeContext?){
    }
}
```
*For the time being the  ‘RuntimeContext’ is an empty class*

```Swift
class RuntimeContext {







```Swift
class NumericExpression:Expression{
Since the class is derived from Expression, it ought to implement the evaluate method. In the Numeric Constant node, we will store a IEEE 754 double precision value. While evaluating the tree, the node will return the value stored inside the object. 

####Binary Expression


```Swift
class BinaryExpression:Expression{
####Unary Expression 


```Swift
public class UnaryExpression:Expression{
We will include the LLVM IR Generator before composing the expression. 

```Swift
var exp:Expression = BinaryExpression(NumericConstant(5) , NumericConstant(10), .plus)