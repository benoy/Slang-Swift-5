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

        if index >= self.count {
            
            return ""
        }
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
    
    var lines: [String] {
        get{
            var result: [String] = []
            enumerateLines { line, _ in result.append(line) }
            
            return result
        }
    }
}

