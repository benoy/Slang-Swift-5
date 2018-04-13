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

public class ParserException:Error{
    
    public var errorCode:Int = 0
    public var errorString:String = ""
    public var lexicalOffset:Int = 0
    
    init( _ iCode:Int , _ iString:String , _ iLexicalOffset:Int){
        self.errorCode = iCode
        self.errorString = iString
        self.lexicalOffset = iLexicalOffset
    }
}

public class SemanticErrorLog{
    private static var errorCount:Int = 0
    private static var list:[String] = [String]()
    
    static func cleanup(){
        list.removeAll()
        errorCount = 0
    }
    
    static func getLog()->String{
        
        var str:String  = "Logged data by the user and processing status" + "\r\n"
        str += "--------------------------------------\r\n"
        
        if list.count == 0{
            str += "NILL" + "\r\n"
        }else{
            for st in list{
                str += st
            }
        }
        str += "--------------------------------------\r\n"
        
        return str
    }
    
    static func addLine(_ iStr:String){
        list.append(iStr)
        errorCount += 1
    }
    
    static func addFromUser(_ iStr:String){
        list.append(iStr)
        errorCount += 1
    }
}

public class SyntaxErrorLog{

    private static var errorCount:Int = 0
    private static var list:[String] = [String]()
    
    static func cleanup(){
        list.removeAll()
        errorCount = 0
    }
    
    static func getLog()->String{
        
        var str:String  = "Syntax Error" + "\r\n"
        str += "--------------------------------------\r\n"
        
        if list.count == 0{
            str += "NILL" + "\r\n"
        }else{
            for st in list{
                str += st
            }
        }
        str += "--------------------------------------\r\n"
        
        return str
    }
    
    static func addLine(_ iStr:String){
        list.append(iStr)
        errorCount += 1
    }
    
    static func addFromUser(_ iStr:String){
        list.append(iStr)
        errorCount += 1
    }
}

enum SlangError:Error{
    
    case runtimeError
    case missingParenthessis
    case illegalToken
    case invalidExpression
    case typeMismatchError
    case undefinedSymbol
    case syntaxError
    case variableNotFound
    case missingOperator
    
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
            case .typeMismatchError:
                return "Type mismatch"
            case .undefinedSymbol:
                return "Undefined symbol"
            case .syntaxError:
                return "Syntax error"
            case .variableNotFound:
                return "Variable not found"
            case .missingOperator:
                return "Missing operator"
            }
        }
    }
}
