////////////////////////////////////////////////////////
//
//  This software is released as per the clauses of MIT License
//
//
//  The MIT License
//
//  Copyright (c) 2016, Binoy Vijayan.
//
//                      benoy.apple@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//

import Foundation

public class RDParser:Lexer{
    
    override init(_ iExpStr:String){
        super.init(iExpStr)
    }
    
    private func getExpression( _ icContext:CompilationContext?) throws ->Expression?{

        var retVal:Expression? = try getTerm(icContext)
        while currentToken == .plus || currentToken == .minus{
            let lToken = currentToken
            getNextToken()
            let tempExp = try getExpression(icContext)
            if lToken == .plus{
                retVal = BinaryPlus(retVal!, tempExp!)
            }else if lToken == .minus{
                retVal = BinaryMinus(retVal!, tempExp!)
            }
        }
        
        return retVal
    }
    
    private func getTerm(_ icContext:CompilationContext?) throws ->Expression?{
       
        var retVal:Expression? = try getFactor(icContext)
        while currentToken == .times || currentToken == .divide{
            let lToken = currentToken
            getNextToken()
            let tempExp = try getTerm(icContext)
            if lToken == .times{
                retVal = Multiplication(retVal!, tempExp!)
            }else if lToken == .divide{
                retVal = Division(retVal!, retVal!)
            }
        }
        
        return retVal
    }
    
    private func getFactor(_ icContext:CompilationContext?) throws -> Expression?{
        
        var retVal:Expression? = nil
        
        if  currentToken == .numeric {
            retVal = NumericConstant(self.number)
            getNextToken()
        }else if currentToken == .string{
            retVal = StringLitteral(lastStr)
            getNextToken()
        }else if currentToken == .boolFalse || currentToken == .boolTrue{
            retVal = BooleanConstant( currentToken == .boolTrue ? true : false)
            getNextToken()
        }else if currentToken == .oParen{
            getNextToken()
            retVal = try getExpression(icContext)
            if currentToken != .cParen{
                print("Missing Closing Parenthesis")
                throw SlangError.missingParenthessis
            }
            getNextToken()
        }else if currentToken == .plus || currentToken == .minus {
            let lToken = currentToken
            getNextToken()
            retVal = try getFactor(icContext)
            if lToken == .plus{
                retVal = UnaryPlus(retVal!)
            }else if lToken == .minus{
                retVal = UnaryMinus(retVal!)
            }
        }else if currentToken == .unquotedString{
            
            guard let info = icContext?.sybolTable?.get(lastStr) else{
                throw SlangError.undefinedSymbol
            }
            getNextToken()
            retVal = Variable(info)
        }
        else{
            print("Illegal Token")
            throw SlangError.illegalToken
        }
        
        return retVal
    }
    
    public func parse(_ icContext:CompilationContext?)->[Statement]{
        getNextToken()
        
        return getStatementList(icContext)
    }
    
    private func getStatementList(_ icContext:CompilationContext? )->[Statement]{
        
        var retStatements:[Statement] = [Statement]()
        while currentToken != .null{
            do{
                let temStmt = try getStatement(icContext)
                retStatements.append(temStmt!)
            }catch SlangError.invalidExpression{
                print(SlangError.invalidExpression.discription)
            }catch{
                print("Unknown error")
            }
        }
        
        return retStatements
    }
    
    private func getStatement( _ icContext:CompilationContext? ) throws ->Statement?{
        
        var retVal:Statement? = nil
        switch currentToken {
            case .varNumber, .varBool , .varString:
                retVal = try parseVariableDeclStatement(icContext)
                getNextToken()
            case .print:
                retVal = try parsePrintStatement(icContext)
                getNextToken()
            case .println:
                retVal = try parsePrintlnStatement(icContext)
                getNextToken()
            case .unquotedString:
                retVal = try parseAssignmentStatement(icContext)
                getNextToken()
            default:
                print("Invalid statement")
                throw SlangError.invalidExpression
        }
        
        return retVal
    }
    
    private func parsePrintStatement(_ icContext:CompilationContext? ) throws ->Statement{
        
        getNextToken()
        let exp = try getExpression(icContext)
        if currentToken != .semi{
            throw SlangError.invalidExpression
        }
        
        return PrintStatement(exp!)
    }

    private func parsePrintlnStatement(_ icContext:CompilationContext? ) throws ->Statement{
        
        getNextToken()
        let exp = try getExpression(icContext)
        if currentToken != .semi{
            throw SlangError.invalidExpression
        }
        
        return PrintLineStatement(exp!)
    }
    
    func parseVariableDeclStatement(_ icContext:CompilationContext?) throws ->Statement{
        
        getNextToken()
        if currentToken == .unquotedString{
            let sInfo = SymbolInfo()
            sInfo.name = lastStr
            sInfo.type = lastToken == .varBool ? .bool : (lastToken == .varNumber ? .numeric :.string )
            getNextToken()
            if currentToken == .semi{
                icContext?.sybolTable?.add(sInfo)
                return VariableDeclStatement(sInfo)
            }else{
                SyntaxErrorLog.addLine("; expected")
                SyntaxErrorLog.addLine(getCurrentLine(index))
                throw ParserException(-100, ", or ; expected", index)
            }
            
        }else{
            SyntaxErrorLog.addLine("invalid variable declaration")
            SyntaxErrorLog.addLine(getCurrentLine(index))
            throw ParserException(-100, ", or ; expected", index)
        }
    }
    
    private func parseAssignmentStatement(_ icContext:CompilationContext? ) throws ->Statement{
        
        guard let symbolInfo = icContext?.sybolTable?.get(lastStr) else{
            
            SyntaxErrorLog.addLine("Variable not found \(lastStr)")
            SyntaxErrorLog.addLine(getCurrentLine(index))
            throw ParserException(-100, "Variable not found",index)
        }
        getNextToken()
        if currentToken != .assign{
            SyntaxErrorLog.addLine("= expected")
            SyntaxErrorLog.addLine(getCurrentLine(index))
            throw ParserException(-100, "= expected", index)
        }
        getNextToken()
        
        let exp = try getExpression(icContext)
        let tp = try exp?.typeCheck(icContext)

        if tp != symbolInfo.type{
            throw SlangError.typeMismatchError
        }
        
        if currentToken != .semi{
            SyntaxErrorLog.addLine("= expected")
            SyntaxErrorLog.addLine(getCurrentLine(index))
            throw ParserException(-100, "= expected", index)
        }
        
        return AssignmentStatement(symbolInfo , exp!)
    }
}
