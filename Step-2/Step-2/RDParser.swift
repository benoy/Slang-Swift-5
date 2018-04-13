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
    
    var discription:String{
        get{
            switch self {
            case .runtimeError :
                return "Runtume error"
            case .missingParenthessis :
                return "Missing parenthesis error"
            case .illegalToken :
                return "Illegal token error"
            }
        }
    }
}

public class RDParser:Lexer{
    
    private var currentToken:Token = .illegal
    
    override init(_ iExpStr:String){
        super.init(iExpStr)
    }
    
    public func callExpression()->Expression?{
        
        currentToken = getToken()
        do{
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
    
    private func getExpression() throws ->Expression?{
        
        var tempToken:Token
        var retVal:Expression? = try getTerm()
        
        while currentToken == .plus || currentToken == .minus{
            tempToken = currentToken
            currentToken = getToken()
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
            currentToken = getToken()
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
            currentToken = getToken()
        }else if currentToken == .oParen{
            currentToken = getToken()
            retVal = try getExpression()
            if currentToken != .cParen{
                print("Missing Closing Parenthesis")
                throw SlangError.missingParenthessis
            }
            currentToken = getToken()
        }else if currentToken == .plus || currentToken == .minus {
            tempToken = currentToken
            currentToken = getToken()
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
