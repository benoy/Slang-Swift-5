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

/*
 String extension for accessing characters as String by subscript
 */
extension String{
    
    subscript(index:Int) -> String{
        
        let chars = Array(self)
        let str:String = String(chars[index])
        
        return str
    }
    
    var isLetter:Bool{
        
        get{
            let byte: UInt8 = Array(self.utf8)[0]
            if (byte >= 65 && byte <= 90) || (byte >= 97 && byte <= 122) {
                return true
            }
            
            return false
        }
    }
    
    var isDigit:Bool{
        
        get{
            
            let byte: UInt8 = Array(self.utf8)[0]
            if byte >= 48 && byte <= 57 {
                return true
            }
            
            return false
        }
    }
    
  
    
    var isLetterOrDigit:Bool{
        get{
            if self.isLetter  || self.isDigit {
                return true
            }
            return false
        }
    }
}

public enum Token{
    
    case illegal
    case plus
    case minus
    case times
    case divide
    case oParen
    case cParen
    case double
    case null
    case print
    case println
    case unquotedString
    case semi
}

public struct ValueTable{
    public var token:Token = .illegal
    public var value:String = ""
    
    init( _ iToken:Token , _ iValue:String){
        
        self.token = iToken
        self.value = iValue
    }
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
    private var index:Int = 0
    private var length:Int = 0
    private var lastStr:String = ""
    
    private var valueTables = [ValueTable( .print,"PRINT"),ValueTable(.println,"PRINTLINE") ]
    
    
    
    init(_ iExpStr:String){
        self.expStr = iExpStr
        length = iExpStr.count
    }
    
    

   
    
    public func getToken() throws ->Token{
        
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
                case "+":
                    token = .plus
                    index += 1
                case "-":
                    token = .minus
                    index += 1
                case "*":
                    token = .times
                    index += 1
                case "/":
                    token = .divide
                    index += 1
                case "(":
                    token = .oParen
                    index += 1
                case ")":
                    token = .cParen
                    index += 1
                case ";":
                    token = .semi
                    index += 1
                case "0","1","2","3","4","5","6","7","8","9":
                    var str:String = ""
                    while index < length && (
                                                expStr[index] == "0" ||
                                                expStr[index] == "1" ||
                                                expStr[index] == "2" ||
                                                expStr[index] == "3" ||
                                                expStr[index] == "4" ||
                                                expStr[index] == "5" ||
                                                expStr[index] == "6" ||
                                                expStr[index] == "7" ||
                                                expStr[index] == "8" ||
                                                expStr[index] == "9"
                                            ){
                        str += expStr[index]
                        index += 1
                    }
                    number = Double(str)!
                    token = .double
                default:
                    if expStr[index].isLetter {
                        var temp = expStr[index]
                        index += 1
                        while index < length && (expStr[index].isLetterOrDigit ||  expStr[index] == "_"){
                            temp += expStr[index]
                            index += 1
                        }
                        temp = temp.uppercased()
                        for val in valueTables{
                            if val.value == temp{
                                token = val.token
                                return token
                            }
                        }
                        lastStr = temp
                        return .unquotedString
                    }else{
                        print("Error \(expStr[index])")
                        throw SlangError.illegalToken
                    }
                }
        }
        return token
    }
}



