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

public class SymbolInfo{
    
    var name:String = ""
    var type:TypeInfo = .illegal
    var double:Double = 0.0
    var bool:Bool = false
    var string:String = ""
}

public class SymbolTable{
    
    private var table:[String:SymbolInfo] = [String:SymbolInfo]()
    
    public func add(_ symbolInfo:SymbolInfo){
        table[symbolInfo.name] = symbolInfo
    }
    
    public func get(_ iName:String)->SymbolInfo{
        
        return table[iName]!
    }
    
    public func assign(_ iVariable:Variable , _ iInfo:SymbolInfo ){
        iInfo.name = iVariable.name
        table[iInfo.name] = iInfo
    }
    
    public func assign(_ iName:String , _ iInfo:SymbolInfo ){
        
        table[iName] = iInfo
    }
    
    
}
