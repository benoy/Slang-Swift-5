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

enum SlangError:Error{
    
    case runtimeError
    case missingParenthessis
    case illegalToken
    case invalidExpression
    
    var discription:String{
        get{
            switch self {
            case .runtimeError :
                return "Runtume error"
            case .missingParenthessis :
                return "Missing parenthesis error"
            case .illegalToken :
                return "Illegal token error"
            case .invalidExpression:
                return "Invalid expression"
            }
        }
    }
}

public class RDParser:Lexer{
    
    private var currentToken:Token = .illegal
    
    override init(_ iExpStr:String){
        super.init(iExpStr)
    }
    
    public func parse()->[Statement]{
        
        getNext()
        return getStatementList()
    }
    
    public func callExpression()->Expression?{
        
        
        do{
            currentToken = try getToken()
            let tempExp = try getExpression()
            return tempExp
        }catch SlangError.runtimeError{
            print(SlangError.runtimeError.discription)
        }catch SlangError.missingParenthessis{
            print(SlangError.missingParenthessis.discription)
        }catch SlangError.illegalToken{
            print(SlangError.illegalToken.discription)
        }catch{
            print("Unknow error")
        }
        
        return nil
    }
    
    private func getStatementList()->[Statement]{
        
        var retStatements:[Statement] = [Statement]()
        while currentToken != .null{
            do{
                let temStmt = try getStatement()
                retStatements.append(temStmt!)
            }catch SlangError.invalidExpression{
                print(SlangError.invalidExpression.discription)
            }catch{
                print("Unknown error")
            }
        }
        
        return retStatements
    }
    
    private func getStatement() throws ->Statement?{
        
        var retVal:Statement? = nil
        switch currentToken {
            case .print:
                retVal = try parsePrintStatement()
                getNext()
            case .println:
                retVal = try parsePrintlnStatement()
                getNext()
            default:
                print("Invalid statement")
                throw SlangError.invalidExpression
       }
        
        return retVal
    }
    
    private func parsePrintStatement() throws ->Statement{
        
       getNextToken()
        let exp = try getExpression()
        if currentToken != .semi{
            throw SlangError.invalidExpression
        }
        
        return PrintStatement(exp!)
    }
    
    private func parsePrintlnStatement() throws ->Statement{
        
        getNextToken()
        let exp = try getExpression()
        if currentToken != .semi{
            throw SlangError.invalidExpression
        }
        
        return PrintLineStatement(exp!)
    }
    
    private func getNext(){
        do{
            currentToken = try getToken()
        }catch SlangError.illegalToken {
            currentToken = .illegal
            print(SlangError.illegalToken.discription)
        }catch{
            currentToken = .illegal
            print("Unknown error")
        }
    }
    
    private func getExpression() throws ->Expression?{
        
        var tempToken:Token
        var retVal:Expression? = try getTerm()
        
        while currentToken == .plus || currentToken == .minus{
            tempToken = currentToken
            getNext()
            let tempExp = try getExpression()
            let op = tempToken == .plus ? Operator.plus : Operator.minus
            retVal = BinaryExpression(retVal!,tempExp!,op)
        }
        
        return retVal
    }
    
    private func getTerm() throws ->Expression?{
        var tempToken:Token
        var retVal:Expression? = try getFactor()
        while currentToken == .times || currentToken == .divide{
            tempToken = currentToken
            getNext()
            let tempExp = try getTerm()
            let op = tempToken == .times ? Operator.times : Operator.divide
            retVal = BinaryExpression(retVal!,tempExp!,op)
        }
        
        return retVal
    }
    
    private func getFactor() throws -> Expression?{
        
        var tempToken:Token
        var retVal:Expression? = nil
        
        if  currentToken == .double {
            retVal = NumericConstant(self.number)
            getNext()
        }else if currentToken == .oParen{
            getNext()
            retVal = try getExpression()
            if currentToken != .cParen{
                print("Missing Closing Parenthesis")
                throw SlangError.missingParenthessis
            }
            getNext()
        }else if currentToken == .plus || currentToken == .minus {
            tempToken = currentToken
            getNext()
            retVal = try getFactor()
            let op = tempToken == .plus ? Operator.plus : Operator.minus
            retVal = UnaryExpression(retVal!,op)
        }else{
            print("Illegal Token")
            throw SlangError.illegalToken
        }
        
        return retVal
    }
}
