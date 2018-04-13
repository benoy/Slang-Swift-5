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


public enum Token{
    
    case illegal
    case plus
    case minus
    case times
    case divide
    case oParen
    case cParen
    
    case null
    case print
    case println
    case unquotedString
    case semi
    
    case varNumber
    case varString
    case varBool
    case numeric
    case comment
    case boolTrue
    case boolFalse
    case string
    case assign
}

public struct ValueTable{
    public var token:Token = .illegal
    public var value:String = ""
    
    init( _ iToken:Token , _ iValue:String){
        
        self.token = iToken
        self.value = iValue
    }
}

public enum Operator{
    case plus
    case minus
    case times
    case divide
}

public enum TypeInfo{
    
    case illegal
    case numeric
    case bool
    case string
}

/*
 
     A naive Lexical analyzer which looks for operators , Parenthesis
     and number. All numbers are treated as IEEE doubles. Only numbers
     without decimals can be entered. Feel free to modify the code
     to accomodate LONG and Double values
 
 */

public class Lexer{
    
    public var number:Double = 0
    private var expStr:String = ""
    
    private var length:Int = 0
    
    var index:Int = 0
    var lastStr:String = ""
    var currentToken:Token = .illegal
    var lastToken:Token = .illegal
    
    private var keyWords = [
                                ValueTable( .boolTrue,"TRUE"),
                                ValueTable( .boolFalse,"FALSE"),
                                ValueTable( .varBool,"BOOLEAN"),
                                ValueTable( .varString,"STRING"),
                                ValueTable( .varNumber,"NUMERIC"),
                                ValueTable( .print,"PRINT"),
                                ValueTable(.println,"PRINTLINE")
                            ]
    
    
    
    init(_ iExpStr:String){
        self.expStr = iExpStr
        length = iExpStr.count
    }
    
    func getNextToken() {
        lastToken = currentToken
        currentToken =  getToken()
    }
    
    func getCurrentLine( _ pIndex:Int) ->String{
        
        return expStr.lines[pIndex]
        
//        var tIndex = pIndex
//        if pIndex >= length{
//            tIndex = length - 1
//        }
//
//        while tIndex > 0 && expStr[tIndex] != "\n"{
//            tIndex -= 1
//        }
//
//        if expStr[tIndex] == "\n" {
//            tIndex += 1
//        }
//
//        var retCurrentLine = ""
//        while tIndex < length && expStr[tIndex] != "\n"{
//            retCurrentLine += expStr[tIndex]
//            tIndex += 1
//        }
//        retCurrentLine += "\n"
//
//        return retCurrentLine
    }
    
    func getPreviousLine( _ pIndex:Int) ->String{
        
         return expStr.lines[pIndex - 1]
//        var tIndex = pIndex
//        if pIndex >= length{
//            tIndex = length - 1
//        }
//
//        while tIndex > 0 && expStr[tIndex] != "\n"{
//            tIndex -= 1
//        }
//
//        if expStr[tIndex] == "\n" {
//            tIndex -= 1
//        }else{
//            return ""
//        }
//
//        while tIndex > 0 && expStr[tIndex] != "\n"{
//            tIndex -= 1
//        }
//
//        if expStr[tIndex] == "\n" {
//            tIndex -= 1
//        }
//
//        var retCurrentLine = ""
//        while tIndex < length && expStr[tIndex] != "\n"{
//            retCurrentLine += expStr[tIndex]
//            tIndex += 1
//        }
//        retCurrentLine += "\n"
//
//        return retCurrentLine
    }
    
    
    func restoreIndex( _ iIndex:Int){
        index = iIndex
    }
    
    private func extractString()->String{
        
        var retString = ""
        while index < length && (expStr[index].isLetterOrDigit || expStr[index] == "_") {
            retString += expStr[index]
            index += 1
        }
        
        return retString
    }
    

    private func skipToEndOfLine(){
        

        var skipedLine = ""
        while index < length && expStr[index] != "\r\n" {
            
            skipedLine += expStr[index]
            index += 1
        }
        
        if index == length {
            return
        }
        
        if expStr[index + 1] == "\n"{
            index += 2
            
            return
        }
        index += 1
        
        return
    }
    
    private func getToken()->Token{
        
        var token:Token = .illegal
        
        var reStart = true
        while reStart{
            reStart = false
        // Skip the white space
            while index < length && (expStr[index] == "\t" || expStr[index] == " "){
                index += 1
            }
            
            // End of the string? return null
            if index == length {
                return .null
            }
            
            switch expStr[index] {
                case "\n":
                    token = .illegal
                    index += 1
                    reStart = true
                    continue
                case "\r":
                    token = .illegal
                    index += 1
                    reStart = true
                    continue
                case "\r\n":
                    token = .illegal
                    index += 1
                    reStart = true
                    continue
                case "+":
                    token = .plus
                    index += 1
                    return token
                
                case "-":
                    token = .minus
                    index += 1
                    return token
                case "*":
                    token = .times
                    index += 1
                    return token
                case "/":
                    
                    if expStr[index + 1] == "/" {
                        skipToEndOfLine()
                        reStart = true
                        continue
                    }else{
                        token = .divide
                        index += 1
                        return token
                    }
                case "(":
                    token = .oParen
                    index += 1
                    return token
                case ")":
                    token = .cParen
                    index += 1
                    return token
                case ";":
                    token = .semi
                    index += 1
                    return token
                case "=":
                    token = .assign
                    index += 1
                    return token
                case "\"":
                    var tmpStr = ""
                    index += 1
                    while index < length && expStr[index] != "\""{
                        tmpStr += expStr[index]
                        index += 1
                    }
                    if index == length{
                        token = .illegal
                        
                        return token
                    }else{
                        index += 1
                        lastStr = tmpStr
                        token = .string
                        
                        return token
                    }
                default:
                    if expStr[index].isDigit {
                        var numStr = ""
                        while index < length && expStr[index].isDigit{
                            numStr += expStr[index]
                            index += 1
                        }
                        if expStr[index] == "."{
                            numStr += expStr[index]
                            index += 1
                            while index < length && expStr[index].isDigit{
                                numStr += expStr[index]
                                index += 1
                            }
                        }
                        number = Double(numStr)!
                        
                        token = .numeric
                        
                    }else if expStr[index].isLetter{
                        var tempStr = expStr[index]
                        index += 1
                        while index < length && (expStr[index].isLetterOrDigit || expStr[index] == "_"){
                            tempStr += expStr[index]
                            index += 1
                        }
                        tempStr = tempStr.uppercased()
                        for kwd in keyWords{
                            if kwd.value == tempStr{
                                token = kwd.token
                                
                                return token
                            }
                        }
                        
                        lastStr = tempStr

                        return .unquotedString
                    }else{
                        return .illegal
                    }
                }
        }
        return token
    }
}



